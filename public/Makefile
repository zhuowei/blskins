TARGETS := index.html nameerr.html fileerr.html lbsg.html lbsg_err.html epicmc.html epicmc_err.html desktop.html
all: $(TARGETS)

%.html: %.html.h
	cpp -P -o $@ $<

clean:
	rm $(TARGETS) *_capes.html
