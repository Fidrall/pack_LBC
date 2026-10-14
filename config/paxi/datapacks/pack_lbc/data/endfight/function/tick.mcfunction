# pack_lbc : EDFR ne tourne que si un joueur est dans l'End (voir build-datapack section 16)
execute in minecraft:the_end if entity @a[x=0,y=0,z=0,distance=0..] in minecraft:overworld run function pack_lbc:edfr/tick
execute in minecraft:the_end unless entity @a[x=0,y=0,z=0,distance=0..] if entity @a[tag=playerMusic] run function pack_lbc:edfr/coupe_musique
execute in minecraft:the_end unless entity @a[x=0,y=0,z=0,distance=0..] if entity @a[tag=playerMusicMAD] run function pack_lbc:edfr/coupe_musique
