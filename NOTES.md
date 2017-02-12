# Save SVG as PNG

var svg = document.getElementById('avatar'),
    xml = new XMLSerializer().serializeToString(svg),
    data = "data:image/svg+xml;base64," + btoa(xml),
    canvas = document.createElement('canvas'),
    ctx = canvas.getContext('2d'),
    img = document.createElement('img');

img.setAttribute('src', data);
img.onload = function() {
    ctx.drawImage(img, 0, 0);
}

document.body.appendChild(canvas);
document.body.appendChild(img);
