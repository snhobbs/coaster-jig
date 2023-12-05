top_level_modules:=base-plate.scad foot-plate.scad body-plate.scad
objects_base:=$(top_level_modules:.scad=.svg)  #  replaces .scad extension with .svg
objects_base:=$(objects_base) $(top_level_modules:.scad=.dxf)
objects_base:=$(objects_base) $(top_level_modules:.scad=.png)
objects_base:=$(objects_base) $(top_level_modules:.scad=.eps)

$(info $(top_level_modules))

.PHONY: all
all: ${objects_base}


%.svg: %.scad
	openscad -m make -o $@ $<

%.eps: %.svg 
	inkscape $< -o $@
	#${CMD} -m make -o $@ -d $@.deps $<

%.dxf: %.scad
	openscad -m make -o $@ $<

%.png: %.scad
	openscad -m make -o $@ $< --imgsize 1024,1024 --render #--preview #--viewall --autocenter#--projection=p --colorscheme Sunset# --view axes --view scales --camera translate_x

