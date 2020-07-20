//first event

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
	desc = "An adhomian cylinder."
	icon = 'icons/obj/badmoon.dmi'
	icon_state = "cylinder"
	var/first_part = FALSE
	var/second_part = FALSE
	var/third_ptary = FALSE
	var/first_code
	var/second_code
	var/third_code
	var/fourth_code

