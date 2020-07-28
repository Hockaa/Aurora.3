/obj/machinery/vending/casino
	name = "grand romanovich vending machine"
	desc = "A vending machine commonly found in Crevus casinos."
	icon_state = "catvend"
	product_slogans = "The House always wins!;Spends your chips right here!;Let Go and Begin Again..."
	product_ads = "Finding it, though, that's not the hard part. It's letting go."
	vend_id = "casino"
	products = list(
		/obj/item/coin/casino = 50
	)
	contraband = list(
		/obj/item/ammo_magazine/boltaction = 2
	)
	premium = list(
		/obj/item/gun/projectile/shotgun/pump/rifle/blank = 3,
		/obj/item/ammo_magazine/boltaction/blank = 10,
		/obj/item/storage/chewables/tobacco/bad = 5,
		/obj/item/reagent_containers/food/drinks/bottle/messa_mead = 5,
		/obj/item/reagent_containers/food/drinks/bottle/victorygin = 5,
		/obj/item/reagent_containers/food/drinks/bottle/pwine = 5,
		/obj/item/reagent_containers/food/snacks/hardbread = 5,
		/obj/item/reagent_containers/food/drinks/cans/adhomai_milk = 5,
		/obj/item/reagent_containers/food/snacks/adhomian_can = 5,
		/obj/item/reagent_containers/food/snacks/clam = 5,
		/obj/item/reagent_containers/food/snacks/tajaran_bread = 5,
		/obj/item/storage/box/fancy/cigarettes/pra = 3,
		/obj/item/storage/box/fancy/cigarettes/dpra = 3,
		/obj/item/storage/box/fancy/cigarettes/nka = 3,
		/obj/item/pocketwatch/adhomai = 2,
		/obj/item/flame/lighter/adhomai = 2,
		/obj/item/toy/plushie/farwa = 2,
		/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/farwacube = 2,
		/obj/item/razor = 2,
		/obj/item/toy/syndicateballoon = 2,
		/obj/item/grenade/fake = 2,
		/obj/item/eightball/haunted = 5,
		/obj/item/spirit_board = 5,
		/obj/item/device/flashlight/maglight = 5,
		/obj/item/contraband/poster = 5,
		/obj/item/spacecash/ewallet/lotto = 15,
		/obj/item/device/laser_pointer = 5,
		/obj/item/beach_ball/holoball = 1,
		/obj/item/material/knife/butterfly/switchblade = 2,
		/obj/item/reagent_containers/hypospray/autoinjector/stimpack = 2,
		/obj/item/clothing/shoes/tajara = 2,
		/obj/item/clothing/under/tajaran/summer = 2,
		/obj/item/clothing/under/pants/tajaran = 2,
		/obj/item/clothing/under/dress/tajaran =2,
		/obj/item/clothing/under/dress/tajaran/blue = 2,
		/obj/item/clothing/under/dress/tajaran/green = 2,
		/obj/item/clothing/under/dress/tajaran/red = 2,
		/obj/item/clothing/head/tajaran/circlet = 2,
		/obj/item/clothing/head/tajaran/circlet/silver = 2,
		/obj/item/gun/energy/lasertag/red = 2,
		/obj/item/clothing/suit/redtag = 2,
		/obj/item/gun/energy/lasertag/blue = 2,
		/obj/item/clothing/suit/bluetag = 2
		)

	prices = list(
		/obj/item/coin/casino = 300
	)

	restock_items = 0
	random_itemcount = 0

/obj/machinery/computer/slot_machine/casino
	specialcoin = /obj/item/coin/casino

/obj/item/ammo_magazine/boltaction/blank
	ammo_type = /obj/item/ammo_casing/a762/blank

/obj/structure/casino/roulette
	name = "roulette"
	desc = "Spin the roulette to try your luck."
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "roulette_r"
	density = 1
	anchored = 1
	var/busy=0

/obj/structure/casino/roulette/attack_hand(mob/user as mob)
	if (busy)
		to_chat(user,"<span class='notice'>You cannot spin now! \The [src] is already spinning.</span> ")
		return
	visible_message("<span class='notice'>[user] spins the roulette and throws inside little ball.</span>")
	busy = 1
	var/n = rand(0,36)
	var/color = "green"
	add_fingerprint(user)
	if ((n>0 && n<11) || (n>18 && n<29))
		if (n%2)
			color="red"
	else
		color="black"
	if ( (n>10 && n<19) || (n>28) )
		if (n%2)
			color="black"
	else
		color="red"
	spawn(5 SECONDS)
		visible_message("<span class='notice'>\The [src] stops spinning, the ball landing on [n], [color].</span>")
		busy=0

/obj/structure/casino/roulette_chart
	name = "roulette chart"
	desc = "Roulette chart. Place your bets! "
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "roulette_l"
	density = 1
	anchored = 1

/obj/structure/casino/attackby(obj/item/W as obj, mob/user as mob, var/click_parameters)
	if (!W) return

	if(user.unEquip(W, 0, src.loc))
		user.make_item_drop_sound(W)
		return 1

/obj/item/storage/bag/money/casino/New()
	..()
	new /obj/item/coin/casino(src)
	new /obj/item/coin/casino(src)
	new /obj/item/coin/casino(src)
	new /obj/item/coin/casino(src)

/obj/vehicle/bike/monowheel/casino
	desc = "A one-wheeled vehicle, fairly popular with Little Adhomai's greasers. There is a coin slot on the panel."
	var/paid = FALSE

/obj/vehicle/bike/monowheel/casino/Move(var/turf/destination)
	if(!paid)
		return
	..()

/obj/vehicle/bike/monowheel/casino/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/coin/casino))
		if(!paid)
			paid = TRUE
			user.drop_from_inventory(W,src)
			qdel(W)
			to_chat(user, "<span class='notice'>Payment confirmed, enjoy two minutes of unlimited [src] use!</span>")
			addtimer(CALLBACK(src, .proc/rearm), 2 MINUTES)
		return
	..()

/obj/vehicle/bike/monowheel/casino/proc/rearm()
	src.visible_message("<span class='notice'>\The [src] hisses lowly, asking for another chip to continue.</span>")
	paid = FALSE

/obj/item/coin/casino
	name = "grand romanovich casino chip"
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "catcoin"

/obj/item/coin/casino/attack_self(mob/user as mob)
	return

/obj/item/ammo_casing/a762/blank
	desc = "A 7.62mm blank casing."
	projectile_type = /obj/item/projectile/bullet/blank

/obj/item/gun/projectile/shotgun/pump/rifle/blank
	ammo_type = /obj/item/ammo_casing/a762/blank


//artifact

/obj/item/cypher
	name = "adhomian cylinder"
	desc = "An adhomian cypher cylinder."
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "cylinder"
	var/list/possible_codes = list("Messa", "S'rendarr", "Raskara", "Kazarrhaldiye", "Almumalik", "Khazan", "Hazzimy", "Aysaif")
	var/first_part = FALSE
	var/second_part = FALSE
	var/third_part = FALSE
	var/first_code
	var/second_code
	var/third_code
	var/fourth_code

/obj/item/cypher/attack_self(var/mob/user)
	var/firstchoice = input(user, "Shift the first wheel.", "First Wheel") as null|anything in possible_codes
	if(firstchoice)
		first_code = firstchoice
		to_chat(user, SPAN_NOTICE("You shift the first wheel to [firstchoice]"))
		playsound(loc, 'sound/items/penclick.ogg', 50, 1)

	if(first_part)
		var/secondchoice = input(user, "Shift the second wheel.", "Second Wheel") as null|anything in possible_codes
		if(secondchoice)
			second_code = secondchoice
			to_chat(user, SPAN_NOTICE("You shift the second wheel to [secondchoice]"))
			playsound(loc, 'sound/items/penclick.ogg', 50, 1)

	if(second_part)
		var/thirdchoice = input(user, "Shift the third wheel.", "Third Wheel") as null|anything in possible_codes
		if(thirdchoice)
			third_code = thirdchoice
			to_chat(user, SPAN_NOTICE("You shift the third wheel to [thirdchoice]"))
			playsound(loc, 'sound/items/penclick.ogg', 50, 1)

	if(third_part)
		var/fourthchoice = input(user, "Shift the fourth wheel.", "Fourth Wheel") as null|anything in possible_codes
		if(fourthchoice)
			fourth_code = fourthchoice
			to_chat(user, SPAN_NOTICE("You shift the fourth wheel to [fourthchoice]"))
			playsound(loc, 'sound/items/penclick.ogg', 50, 1)

/obj/item/cypher/Initialize()
	. = ..()
	update_icon()

/obj/item/cypher/update_icon()
	if(first_part)
		icon_state = "cylinder1"
	if(second_part)
		icon_state = "cylinder2"
	if(third_part)
		icon_state = "cylinder3"

/obj/item/cypher/examine(var/mob/user)
	..()
	if(first_code)
		to_chat(user,("The first wheel is set to [first_code]"))
	if(second_code)
		to_chat(user,("The second wheel is set to [second_code]"))
	if(third_code)
		to_chat(user,("The third wheel is set to [third_code]"))
	if(fourth_code)
		to_chat(user,("The fourth wheel is set to [fourth_code]"))

/obj/item/cypher/attackby(obj/item/W as obj, mob/user as mob)

	if(istype(W, /obj/item/cypher_part_one))
		if(!first_part)
			first_part = TRUE
			qdel(W)
			update_icon()
			to_chat(user,("You add a part to \the [src]"))


	if(istype(W, /obj/item/cypher_part_two))
		if(!second_part)
			second_part = TRUE
			qdel(W)
			update_icon()
			to_chat(user,("You add a part to \the [src]"))

	if(istype(W, /obj/item/cypher_part_three))
		if(!third_part)
			third_part = TRUE
			qdel(W)
			update_icon()
			to_chat(user,("You add a part to \the [src]"))


/obj/item/cypher/first
	first_part = TRUE

/obj/item/cypher/second
	first_part = TRUE
	second_part = TRUE

/obj/item/cypher/complete
	first_part = TRUE
	second_part = TRUE
	third_part = TRUE

/obj/item/cypher_part_one
	name = "adhomian cylinder part"
	desc = "An adhomian cypher cylinder part."
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "piece1"

/obj/item/cypher_part_two
	name = "adhomian cylinder part"
	desc = "An adhomian cypher cylinder part."
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "piece2"

/obj/item/cypher_part_three
	name = "adhomian cylinder part"
	desc = "An adhomian cypher cylinder part."
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "piece3"

/obj/item/material/knife/raskara
	name = "dagger"
	desc = "A twisted looking dagger. It menaces with spikes of steel."
	force_divisor = 0.4
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "dagger"
	item_state = "dagger"
	contained_sprite = TRUE
	w_class = 2
	applies_material_colour = 0
	slot_flags = SLOT_BELT

/obj/item/material/knife/raskara/pickup(mob/living/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.religion != RELIGION_RASKARA)
			var/obj/item/clothing/worn_gloves = H.gloves
			var/obj/item/clothing/worn_suit = H.wear_suit

			if(worn_gloves)
				if(worn_gloves.flags & THICKMATERIAL)
					return

			if(worn_suit)
				if(worn_suit.flags & STOPPRESSUREDAMAGE)
					return

			if(prob(50))
				to_chat(user, SPAN_CULT("A spike bites into your hand when you pick up \the [src]!"))
				user.reagents.add_reagent(/datum/reagent/raskara_poison, 5)

/obj/item/material/knife/raskara/attack(var/mob/target, var/mob/living/user, var/target_zone)
	..()
	if(prob(50))
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			H.reagents.add_reagent(/datum/reagent/raskara_poison, 10)


/datum/reagent/raskara_poison
	name = "Nightmare Concoction"
	description = "A mixture of Adhomian plants that can disable a target."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	taste_description = "acid"
	fallback_specific_heat = 0.75

/datum/reagent/raskara_poison/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.flags & NO_BLOOD))
		return
	M.hallucination = max(M.hallucination, 100)
	M.add_chemical_effect(CE_HALLUCINATE, 2)
	M.make_jittery(5)
	M.make_dizzy(5)
	M.confused = rand(5,15)

/obj/item/cane/shillelagh
	name = "adhomian shillelagh"
	desc = "A cane used by the members of the kin of S’rendarr."
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "shillelagh"
	item_state = "shillelagh"
	contained_sprite = TRUE
	force = 20

/obj/item/cane/shillelagh/handle_shield(mob/user, var/on_back, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(default_parry_check(user, attacker, damage_source) && prob(40))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(user.loc, 'sound/weapons/bladeparry.ogg', 50, 1)
		return 1
	return 0


/obj/item/adhomian_egg
	name = "adhomian fortune-telling mechanism"
	desc = "An adhomian jewelry in the shape of an egg. It is made of rare metals and covered in precious stones. A faint ticking sound can be heard inside of it."
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "egg"
	item_state = "egg"
	w_class = 2

	var/on_cooldown = FALSE
	var/mob/living/simple_animal/speaker

/obj/item/adhomian_egg/Initialize()
	. = ..()
	speaker = new /mob/living/ (src)
	speaker.alpha = 0
	speaker.density = 0
	speaker.mouse_opacity = 0
	speaker.name = "Adhomian fortune-telling mechanism"
	speaker.add_language(LANGUAGE_SIIK_MAAS)
	speaker.set_default_language(LANGUAGE_SIIK_MAAS)
	speaker.universal_speak = TRUE
	speaker.universal_understand = TRUE
	speaker.speak_emote = list("says")

/obj/item/adhomian_egg/attack_self(mob/user)

	if(on_cooldown)
		to_chat(user, "<span class='warning'>\The [src] was spoken to recently, it needs time to rest.</span>")
		return

	var/query = sanitize(input(user,"What is your question?", "Adhomian Fortune-telling Mechanism") as text|null)

	if(!query)
		return

	query = sanitize(query)

	user.visible_message("<span class='notice'>\The [user] whispers something to \the [src].</span>", "<span class='notice'>You whisper a question to \the [src].</span>", "You hear a ticking sound.")

	on_cooldown = TRUE

	ask_question(user, query)

/obj/item/adhomian_egg/proc/ask_question(var/mob, var/question)
	for(var/mob/O in player_list)
		if(O.key == "Alberyk")
			to_chat(O, SPAN_WARNING("[mob] asked: [question]"))
			var/input = input(O, "Answer the question.", "Voice of the egg", "")
			if(input)
				speaker.say("[input]")

				addtimer(CALLBACK(src, .proc/clear_cooldown), 1 MINUTE)

/obj/item/adhomian_egg/proc/clear_cooldown()
	on_cooldown = FALSE

/obj/item/reagent_containers/food/snacks/adhomian_sausage
	name = "fatshouters bloodpudding"
	desc = "A mixture of fatshouters meat, offal, blood and blizzard ears flour."
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "adhomian_sausage"
	filling_color = "#DB0000"
	bitesize = 2

	reagents_to_add = list(/datum/reagent/nutriment/protein = 12)


/obj/item/reagent_containers/food/snacks/fermented_worm
	name = "fermented hma'trra"
	desc = "A larged piece of fermented glacier worm meat."
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "fermented_worm"
	filling_color = "#DB0000"
	bitesize = 2

	reagents_to_add = list(/datum/reagent/nutriment/protein/seafood = 20, /datum/reagent/ammonia = 2)


/obj/item/eguitar
	name = "eletronic guitar"
	desc = "A traditional human eletronic guitar."
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "eguitar"
	item_state = "eguitar"
	contained_sprite = TRUE
	w_class = 2
	force = 10

/obj/item/bass
	name = "adhomian bass"
	desc = "A traditional adhomian bass."
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "guitar"
	item_state = "guitar"
	contained_sprite = TRUE
	w_class = 2
	force = 10

/obj/structure/eletronic_drum
	name = "eletronic drums"
	desc = "An advanced drums simulator."
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "synthesizer"
	anchored = TRUE
	density = TRUE

/obj/item/prrama
	name = "p'rrama"
	desc = "A plucked string Adhomian instrument, with eight strings and four holes at its end."
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "prrama"
	item_state = "prrama"
	contained_sprite = TRUE
	w_class = 2
	slot_flags = SLOT_BELT
	force = 10
	var/recharging = FALSE

/obj/item/prrama/attack_self(mob/user as mob)
	if(recharging)
		return
	if(user.name == "Mih")
		var/choice = input(user, "Play the song?", "Adhomian Metal") as null|anything in list("Yes", "No")
		if(choice == "Yes")
			playsound(loc, 'sound/music/Song3.ogg', 100, 1)
			recharging = TRUE
			addtimer(CALLBACK(src, .proc/rearm), 90 SECONDS)

	return

/obj/item/prrama/proc/rearm()
	recharging = FALSE

/obj/item/clothing/accessory/kin_srendarr
	name = "holy sun rosette"
	desc = "A simple rosette accessory depicting the Tajaran god S'rendarr."
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "rosette"

/obj/item/clothing/under/archeologist
	name = "archeologist uniform"
	desc = "A sturdy archeologist uniform."
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "explorer_uniform"
	item_state = "explorer_uniform"

/obj/item/clothing/suit/storage/archeologist
	name = "archeologist jacket"
	desc = "A sturdy archeologist jacket."
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "explorer_uniform"
	item_state = "explorer_uniform"
	armor = list(melee = 25, bullet = 10, laser = 10, energy = 10, bomb = 5, bio = 0, rad = 0)

/obj/item/clothing/head/archeologist
	name = "archeologist hat"
	desc = "A sturdy archeologist hat."
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "explorer_hat"
	item_state = "explorer_hat"
	armor = list(melee = 25, bullet = 10, laser = 10, energy = 10, bomb = 5, bio = 0, rad = 0)
