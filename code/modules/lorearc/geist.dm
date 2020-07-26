/mob/living/simple_animal/hostile/geist
	name = "creature"
	desc = ""
	speak_emote = list("roars")
	icon = 'icons/mob/npc/geist.dmi'
	icon_state = "geist"
	icon_living = "geist"
	icon_dead = "geist_dead"
	stop_automated_movement = TRUE
	universal_speak = TRUE
	universal_understand = TRUE

	mob_swap_flags = HUMAN|SIMPLE_ANIMAL|SLIME|MONKEY
	mob_push_flags = ALLMOBS

	tameable = FALSE

	response_help  = "pets"
	response_disarm = "shoves"
	response_harm   = "harmlessly punches"
	maxHealth = 1200
	health = 1200
	harm_intent_damage = 0
	melee_damage_lower = 45
	melee_damage_upper = 45
	resist_mod = 3
	mob_size = 25
	environment_smash = 2
	attacktext = "mangled"

	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_NOLIGHTING

	minbodytemp = 0
	maxbodytemp = 350
	min_oxy = 0
	max_co2 = 0
	max_tox = 0

	var/is_devouring = FALSE

/mob/living/simple_animal/hostile/geist/examine(mob/user)
	. = ..()
	if(istajara(user))
		to_chat(user, ("An terrible monster, its description matches the tales involving cavern geists."))
	else
		to_chat(user, ("An unknown creature, something pulled straight from a nightmare"))

/mob/living/simple_animal/hostile/geist/Life()
	..()
	if(prob(25))
		adjustBruteLoss(-10) //it will slowly heal brute damage, making fire/laser a stronger option

/mob/living/simple_animal/hostile/geist/verb/geist_devour(mob/living/target as mob in oview())
	set category = "Geist"
	set name = "Devour"
	set desc = "Devours a creature, destroying its body and regenerating health."

	if(!Adjacent(target))
		return

	if(target.isSynthetic())
		return

	if(src.is_devouring)
		to_chat(src, "<span class='warning'>We are already feasting on something!</span>")
		return 0

	if(!health)
		to_chat(src, "<span class='notice'>We are dead, we cannot use any abilities!</span>")
		return

	if(last_special > world.time)
		to_chat(src, "<span class='warning'>We must wait a little while before we can use this ability again!</span>")
		return

	src.visible_message("<span class='warning'>[src] begins ripping apart and feasting on [target]!</span>")
	src.is_devouring = TRUE

	target.adjustBruteLoss(35)

	if(!do_after(src,150))
		to_chat(src, "<span class='warning'>You need to wait longer to devour \the [target]!</span>")
		src.is_devouring = FALSE
		return 0

	src.visible_message("<span class='warning'>[src] tears a chunk from \the [target]'s flesh!</span>")

	target.adjustBruteLoss(35)

	if(!do_after(src,150))
		to_chat(src, "<span class='warning'>You need to wait longer to devour \the [target]!</span>")
		src.is_devouring = FALSE
		return 0

	src.visible_message("<span class='warning'>[target] is completely devoured by [src]!</span>", \
						"<span class='danger'>You completely devour \the [target]!</span>")
	target.gib()
	rejuvenate()
	updatehealth()
	last_special = world.time + 100
	src.is_devouring = FALSE
	return