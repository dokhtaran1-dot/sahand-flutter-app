"""Preserve source files; create enhanced-size copies, not native 8K captures."""
from pathlib import Path
from PIL import Image, ImageFilter, ImageOps
import json, hashlib

base = Path('assets/image')
out = Path('build/royal_artwork_8k')
out.mkdir(parents=True, exist_ok=True)
home = base / 'ROYAL_ONE_HOME_APPROVED_FINAL.png'
rooms = [base / n for n in [
    'rv_real_poete.jpg', 'rv_real_jardin.jpg', 'rv_real_lumiere.jpg',
    'rv_real_dore.jpg', 'rv_real_royal.jpg', 'rv_real_imperial.jpg',
    'rv_real_noir.jpg', 'rv_real_prive.png', 'rv_real_grand.png']]
report = []
for path in [home, *rooms]:
    raw = path.read_bytes()
    with Image.open(path) as source:
        img = ImageOps.exif_transpose(source).convert('RGB')
        original = img.size
        def resized(long_edge):
            scale = long_edge / max(img.size)
            target = tuple(round(v * scale) for v in img.size)
            return img.resize(target, Image.Resampling.LANCZOS).filter(
                ImageFilter.UnsharpMask(radius=1.1, percent=40, threshold=4))
        # 8K long-edge export; maintain the exact original aspect ratio.
        master = resized(7680)
        master.save(out / (path.stem + '_8K_UPSCALED.jpg'), quality=95, subsampling=0)
        report.append({'source': str(path), 'source_pixels': original,
                       'source_sha256': hashlib.sha256(raw).hexdigest(),
                       'export_pixels': master.size, 'native_8k': False})
        del master
        # Only the Home artwork is enlarged for runtime. Room images remain
        # byte-for-byte originals for fullscreen inspection and zoom.
        if path == home:
            mobile = resized(3840)
            mobile.save(out / 'HOME_4K_UPSCALED.png', format='PNG', compress_level=4)
            report[-1]['runtime_pixels'] = original
        else:
            assert path.read_bytes() == raw
(out / 'quality_manifest.json').write_text(json.dumps(report, indent=2))
print(json.dumps(report, indent=2))
