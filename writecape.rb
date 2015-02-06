require 'RMagick'
include Magick

def writecape(file, outpath)
	blob = file.read
	img = Image.from_blob(blob) {
		self.format = "PNG"
		self.background_color = "transparent"
	}[0]
	img2 = img.extent(64, 32)
	img2.write(outpath)
end
