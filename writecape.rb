require 'RMagick'
include Magick

def writecape(file, outpath)
	blob = file.read
	img = Image.from_blob(blob) {
		self.format = "PNG"
		self.background_color = "transparent"
	}[0]
	if img.columns >= 64 and img.rows >= 32
		File.copy_stream(file, outpath)
		File.chmod(0664, outpath)
		return
	end
	img2 = img.extent(64, 32)
	img2.write(outpath)
	File.chmod(0664, outpath)
end
