/obj/item/gun/projectile/automatic/rifle/adhomian
	name = "adhomian automatic rifle"
	desc = "The Tsarrayut'yan rifle is a select-fire, crew-served automatic rifle producted by the People's Republic of Adhomai."
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "automatic"
	item_state = "automatic"
	contained_sprite = TRUE

	load_method = SINGLE_CASING|SPEEDLOADER

	ammo_type = /obj/item/ammo_casing/a762

	max_shells = 25

	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_rifle.ogg'

/obj/item/gun/projectile/revolver/detective/knife
	name = "knife-revolver"
	desc = "AAn adhomian revolver with a blade attached to its barrel."
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "knifegun"
	item_state = "knifegun"
	contained_sprite = TRUE
	force = 20
	sharp = TRUE
	edge = TRUE

/obj/item/gun/projectile/musket
	name = "adhomai musket"
	desc = "A rustic firearm, used by Tajaran soldiers during the adhomian gunpowder age"
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "musket"
	item_state = "musket"
	contained_sprite = TRUE

	load_method = SINGLE_CASING
	handle_casings = DELETE_CASINGS

	ammo_type = /obj/item/ammo_casing/musket

	max_shells = 1

	slot_flags = SLOT_BACK

	is_wieldable = TRUE

	needspin = FALSE

	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_rifle.ogg'

	fire_delay = 35
	fire_sound = 'sound/effects/Explosion1.ogg'
	recoil = 4

	var/has_powder = FALSE

/obj/item/gun/projectile/musket/special_check(mob/user)
	if(!has_powder)
		return 0

	if(!wielded)
		to_chat(user, "<span class='warning'>You can't fire without stabilizing \the [src]!</span>")
		return 0

	var/datum/effect/effect/system/smoke_spread/smoke = new /datum/effect/effect/system/smoke_spread()
	smoke.set_up(3, 0, user.loc)
	smoke.start()
	has_powder = FALSE
	return ..()

/obj/item/gun/projectile/musket/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/C = W
		if(C.reagents.has_reagent(/datum/reagent/gunpowder, 5))
			C.reagents.remove_reagent(/datum/reagent/gunpowder, 5)
			has_powder = TRUE
			to_chat(user, "<span class='notice'>You fill \the [src] with gunpowder.</span>")

/obj/item/ammo_casing/musket
	name = "lead ball"
	desc = "A lead ball."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "lead_ball"
	caliber = "musket"
	projectile_type = /obj/item/projectile/bullet/pistol/strong

/obj/item/reagent_containers/powder_horn
	name = "powder horn"
	desc = "An ivory container for gunpowder."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "powder_horn"
	item_state = "powder_horn"
	contained_sprite = TRUE
	w_class = 2
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5)
	volume = 30
	reagents_to_add = list(/datum/reagent/gunpowder = 30)

/datum/reagent/gunpowder
	name = "Gunpowder"
	description = "A primitive explosive chemical."
	reagent_state = SOLID
	color = "#1C1300"
	ingest_met = REM * 5
	taste_description = "sour chalk"
	taste_mult = 1.5
	fallback_specific_heat = 0.018