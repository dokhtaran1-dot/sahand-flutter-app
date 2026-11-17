"""Extract actual ROOM INTERIOR photo panels from historic user-approved
Royal Village catalogue sheets. Do not use the later advertising-model posters.

Requires:
    git fetch --no-tags --depth=1 origin final-screen-assets
    python3 -m pip install pillow
The seven source posters are fetched verbatim from the original design
branch. The eighth Salon Royale preview is a no-model room visual taken
from the existing user-library Royal room concept (visually verify before
public release). Original catalogue sheets are also copied unmodified.
"""
import base64
import io
from pathlib import Path
import subprocess
from PIL import Image

HERE = Path(__file__).resolve().parents[1]
ROOMS = HERE / 'assets/image/rv_room_photos'
CATALOGUES = HERE / 'assets/image/rv_original_catalogues'
ROOMS.mkdir(parents=True, exist_ok=True)
CATALOGUES.mkdir(parents=True, exist_ok=True)

ROOM_SOURCES = {
    'lumiere': 'salon_lumiere.png',
    'noir': 'salon_noir.png',
    'jardin': 'salon_jardin.png',
    'prive': 'salon_prive.png',
    'rv_lounge_imperial': 'rv_lounge_imperial_classique.png',
    'dore': 'salon_dore.png',
    'ame_du_poete': 'salon_ame_du_poete.png',
}

for room_id, original_filename in ROOM_SOURCES.items():
    raw = subprocess.check_output(
        ['git', 'show', 'FETCH_HEAD:assets/image/' + original_filename],
        cwd=HERE)
    original = Image.open(io.BytesIO(raw)).convert('RGB')
    width, height = original.size
    # Full top-left interior-photo rectangle inside original 2:3 catalogue.
    # All four room-photo edges are retained, removing only the surrounding
    # textual panels, cake thumbnails, and designer profiles.
    box = (round(width * .008), round(height * .014),
           round(width * .582), round(height * .225))
    original.crop(box).save(ROOMS / (room_id + '.jpg'),
                            format='JPEG', quality=94, optimize=True)
    (CATALOGUES / (room_id + '.png')).write_bytes(raw)

royal_file = HERE / 'assets/rv/royal_room_jpeg.b64'
royal_bytes = base64.b64decode(royal_file.read_text().strip(), validate=True)
assert royal_bytes.startswith(b'\\xff\\xd8'), 'Royal photo JPEG missing'
assert royal_bytes.endswith(b'\\xff\\xd9'), 'Royal photo JPEG incomplete'
(ROOMS / 'royale.jpg').write_bytes(royal_bytes)

for room_id in list(ROOM_SOURCES) + ['royale']:
    image = ROOMS / (room_id + '.jpg')
    with Image.open(image) as photo:
        photo.verify()
    assert image.stat().st_size > 10000, str(image)
    print(room_id, image.stat().st_size, 'original interior image ready')
