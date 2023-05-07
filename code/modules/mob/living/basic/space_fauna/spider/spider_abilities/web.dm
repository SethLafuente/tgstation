/// Make a sticky web under yourself for area fortification
/datum/action/cooldown/lay_web
	name = "Spin Web"
	desc = "Spin a web to slow down potential prey."
	button_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = "lay_web"
	background_icon_state = "bg_alien"
	overlay_icon_state = "bg_alien_border"
	check_flags = AB_CHECK_CONSCIOUS | AB_CHECK_INCAPACITATED
	cooldown_time = 0 SECONDS
	/// How long it takes to lay a web
	var/webbing_time = 4 SECONDS

/datum/action/cooldown/lay_web/Grant(mob/grant_to)
	. = ..()
	if (!owner)
		return
	RegisterSignals(owner, list(COMSIG_MOVABLE_MOVED, COMSIG_DO_AFTER_BEGAN, COMSIG_DO_AFTER_ENDED), PROC_REF(update_status_on_signal))

/datum/action/cooldown/lay_web/Remove(mob/removed_from)
	. = ..()
	UnregisterSignal(removed_from, list(COMSIG_MOVABLE_MOVED, COMSIG_DO_AFTER_BEGAN, COMSIG_DO_AFTER_ENDED))

/datum/action/cooldown/lay_web/IsAvailable(feedback = FALSE)
	. = ..()
	if(!.)
		return FALSE
	if(DOING_INTERACTION(owner, DOAFTER_SOURCE_SPIDER))
		if (feedback)
			owner.balloon_alert(owner, "busy!")
		return FALSE
	if(!isturf(owner.loc))
		if (feedback)
			owner.balloon_alert(owner, "invalid location!")
		return FALSE
	if(obstructed_by_other_web())
		if (feedback)
			owner.balloon_alert(owner, "already webbed!")
		return FALSE
	return TRUE

/// Returns true if there's a web we can't put stuff on in our turf
/datum/action/cooldown/lay_web/proc/obstructed_by_other_web()
	return !!(locate(/obj/structure/spider/stickyweb) in get_turf(owner))

/datum/action/cooldown/lay_web/Activate()
	. = ..()
	var/turf/spider_turf = get_turf(owner)
	var/obj/structure/spider/stickyweb/web = locate() in spider_turf
	if(web)
		owner.balloon_alert_to_viewers("sealing web...")
	else
		owner.balloon_alert_to_viewers("spinning web...")

	if(do_after(owner, webbing_time, target = spider_turf, interaction_key = DOAFTER_SOURCE_SPIDER) && owner.loc == spider_turf)
		plant_web(spider_turf, web)
	else
		owner?.balloon_alert(owner, "interrupted!") // Null check because we might have been interrupted via being disintegrated
	build_all_button_icons()

/// Creates a web in the current turf
/datum/action/cooldown/lay_web/proc/plant_web(turf/target_turf, obj/structure/spider/stickyweb/existing_web)
	new /obj/structure/spider/stickyweb(target_turf)

/// Variant for genetics, created webs only allow the creator passage
/datum/action/cooldown/lay_web/genetic
	desc = "Spin a web. Only you will be able to traverse your web easily."
	cooldown_time = 4 SECONDS //the same time to lay a web

/datum/action/cooldown/lay_web/genetic/plant_web(turf/target_turf, obj/structure/spider/stickyweb/existing_web)
	new /obj/structure/spider/stickyweb/genetic(target_turf, owner)

/// Variant which allows webs to be stacked into walls
/datum/action/cooldown/lay_web/sealer
	desc = "Spin a web to slow down potential prey. Webs can be stacked to make solid structures."

/datum/action/cooldown/lay_web/sealer/plant_web(turf/target_turf, obj/structure/spider/stickyweb/existing_web)
	if (existing_web)
		qdel(existing_web)
		new /obj/structure/spider/stickyweb/sealed(target_turf)
		return
	new /obj/structure/spider/stickyweb(target_turf)

/datum/action/cooldown/lay_web/sealer/obstructed_by_other_web()
	return !!(locate(/obj/structure/spider/stickyweb/sealed) in get_turf(owner))

/// Make a solid web under yourself for area fortification
/datum/action/cooldown/solid_web
	name = "Spin Solid Web"
	desc = "Spin a web to slow down potential prey."
	button_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = "lay_solid_web"
	background_icon_state = "bg_alien"
	overlay_icon_state = "bg_alien_border"
	check_flags = AB_CHECK_CONSCIOUS | AB_CHECK_INCAPACITATED
	cooldown_time = 0 SECONDS
	/// How long it takes to lay a web
	var/webbing_time = 5 SECONDS

/datum/action/cooldown/solid_web/Grant(mob/grant_to)
	. = ..()
	if (!owner)
		return
	RegisterSignals(owner, list(COMSIG_MOVABLE_MOVED, COMSIG_DO_AFTER_BEGAN, COMSIG_DO_AFTER_ENDED), PROC_REF(update_status_on_signal))

/datum/action/cooldown/solid_web/Remove(mob/removed_from)
	. = ..()
	UnregisterSignal(removed_from, list(COMSIG_MOVABLE_MOVED, COMSIG_DO_AFTER_BEGAN, COMSIG_DO_AFTER_ENDED))

/datum/action/cooldown/solid_web/IsAvailable(feedback = FALSE)
	. = ..()
	if(!.)
		return FALSE
	if(DOING_INTERACTION(owner, DOAFTER_SOURCE_SPIDER))
		if (feedback)
			owner.balloon_alert(owner, "busy!")
		return FALSE
	if(!isturf(owner.loc))
		if (feedback)
			owner.balloon_alert(owner, "invalid location!")
		return FALSE
	if(obstructed_by_other_solid_web())
		if (feedback)
			owner.balloon_alert(owner, "already webbed!")
		return FALSE
	return TRUE

/// Returns true if there's a web we can't put stuff on in our turf
/datum/action/cooldown/solid_web/proc/obstructed_by_other_solid_web()
	return !!(locate(/obj/structure/spider/stickyweb/solid) in get_turf(owner))

/datum/action/cooldown/solid_web/Activate()
	. = ..()
	var/turf/spider_turf = get_turf(owner)
	var/obj/structure/spider/stickyweb/solidweb = locate() in spider_turf
	if(solidweb)
		owner.balloon_alert_to_viewers("sealing web...")
	else
		owner.balloon_alert_to_viewers("spinning web...")

	if(do_after(owner, webbing_time, target = spider_turf, interaction_key = DOAFTER_SOURCE_SPIDER) && owner.loc == spider_turf)
		plant_solidweb(spider_turf, solidweb)
	else
		owner?.balloon_alert(owner, "interrupted!") // Null check because we might have been interrupted via being disintegrated
	build_all_button_icons()

/// Creates a web in the current turf
/datum/action/cooldown/solid_web/proc/plant_solidweb(turf/target_turf, obj/structure/spider/solid/existing_web)
	new /obj/structure/spider/stickyweb/solid(target_turf)

/// Make a solid web under yourself for area fortification
/datum/action/cooldown/web_passage
	name = "Spin Web Passage"
	desc = "Spin a web passage to hide the nest from prey view."
	button_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = "lay_web_passage"
	background_icon_state = "bg_alien"
	overlay_icon_state = "bg_alien_border"
	check_flags = AB_CHECK_CONSCIOUS | AB_CHECK_INCAPACITATED
	cooldown_time = 0 SECONDS
	/// How long it takes to lay a web
	var/webbing_time = 4 SECONDS

/datum/action/cooldown/web_passage/Grant(mob/grant_to)
	. = ..()
	if (!owner)
		return
	RegisterSignals(owner, list(COMSIG_MOVABLE_MOVED, COMSIG_DO_AFTER_BEGAN, COMSIG_DO_AFTER_ENDED), PROC_REF(update_status_on_signal))

/datum/action/cooldown/web_passage/Remove(mob/removed_from)
	. = ..()
	UnregisterSignal(removed_from, list(COMSIG_MOVABLE_MOVED, COMSIG_DO_AFTER_BEGAN, COMSIG_DO_AFTER_ENDED))

/datum/action/cooldown/web_passage/IsAvailable(feedback = FALSE)
	. = ..()
	if(!.)
		return FALSE
	if(DOING_INTERACTION(owner, DOAFTER_SOURCE_SPIDER))
		if (feedback)
			owner.balloon_alert(owner, "busy!")
		return FALSE
	if(!isturf(owner.loc))
		if (feedback)
			owner.balloon_alert(owner, "invalid location!")
		return FALSE
	if(obstructed_by_other_web_passage())
		if (feedback)
			owner.balloon_alert(owner, "already webbed!")
		return FALSE
	return TRUE

/// Returns true if there's a web we can't put stuff on in our turf
/datum/action/cooldown/web_passage/proc/obstructed_by_other_web_passage()
	return !!(locate(/obj/structure/spider/passage) in get_turf(owner))

/datum/action/cooldown/web_passage/Activate()
	. = ..()
	var/turf/spider_turf = get_turf(owner)
	var/obj/structure/spider/webpassage = locate() in spider_turf
	if(webpassage)
		owner.balloon_alert_to_viewers("sealing web...")
	else
		owner.balloon_alert_to_viewers("spinning web...")

	if(do_after(owner, webbing_time, target = spider_turf, interaction_key = DOAFTER_SOURCE_SPIDER) && owner.loc == spider_turf)
		plant_webpassage(spider_turf, webpassage)
	else
		owner?.balloon_alert(owner, "interrupted!") // Null check because we might have been interrupted via being disintegrated
	build_all_button_icons()

	/// Creates a web in the current turf
/datum/action/cooldown/web_passage/proc/plant_webpassage(turf/target_turf, obj/structure/spider/passage/existing_web)
	new /obj/structure/spider/passage(target_turf)

/// Make a solid web trap to trap intruders and pray
/datum/action/cooldown/sticky_web
	name = "Spin Sticky Web"
	desc = "Spin a web to stick intruders in place."
	button_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = "lay_sticky_web"
	background_icon_state = "bg_alien"
	overlay_icon_state = "bg_alien_border"
	check_flags = AB_CHECK_CONSCIOUS | AB_CHECK_INCAPACITATED
	cooldown_time = 20 SECONDS
	/// How long it takes to lay a web
	var/webbing_time = 3 SECONDS

/datum/action/cooldown/sticky_web/Grant(mob/grant_to)
	. = ..()
	if (!owner)
		return
	RegisterSignals(owner, list(COMSIG_MOVABLE_MOVED, COMSIG_DO_AFTER_BEGAN, COMSIG_DO_AFTER_ENDED), PROC_REF(update_status_on_signal))

/datum/action/cooldown/sticky_web/Remove(mob/removed_from)
	. = ..()
	UnregisterSignal(removed_from, list(COMSIG_MOVABLE_MOVED, COMSIG_DO_AFTER_BEGAN, COMSIG_DO_AFTER_ENDED))

/datum/action/cooldown/sticky_web/IsAvailable(feedback = FALSE)
	. = ..()
	if(!.)
		return FALSE
	if(DOING_INTERACTION(owner, DOAFTER_SOURCE_SPIDER))
		if (feedback)
			owner.balloon_alert(owner, "busy!")
		return FALSE
	if(!isturf(owner.loc))
		if (feedback)
			owner.balloon_alert(owner, "invalid location!")
		return FALSE
	if(obstructed_by_other_sticky_web())
		if (feedback)
			owner.balloon_alert(owner, "already webbed!")
		return FALSE
	return TRUE

/// Returns true if there's a web we can't put stuff on in our turf
/datum/action/cooldown/sticky_web/proc/obstructed_by_other_sticky_web()
	return !!(locate(/obj/structure/spider/sticky) in get_turf(owner))

/datum/action/cooldown/sticky_web/Activate()
	. = ..()
	var/turf/spider_turf = get_turf(owner)
	var/obj/structure/spider/stickyweb = locate() in spider_turf
	if(stickyweb)
		owner.balloon_alert_to_viewers("sealing web...")
	else
		owner.balloon_alert_to_viewers("spinning web...")

	if(do_after(owner, webbing_time, target = spider_turf, interaction_key = DOAFTER_SOURCE_SPIDER) && owner.loc == spider_turf)
		plant_stickyweb(spider_turf, stickyweb)
	else
		owner?.balloon_alert(owner, "interrupted!") // Null check because we might have been interrupted via being disintegrated
	build_all_button_icons()

	/// Creates a web in the current turf
/datum/action/cooldown/sticky_web/proc/plant_stickyweb(turf/target_turf, obj/structure/spider/sticky/existing_web)
	new /obj/structure/spider/sticky(target_turf)

/// Make a solid web under yourself for area fortification
/datum/action/cooldown/web_spikes
	name = "Spin Web Spikes"
	desc = "Spin a spikes made out of web to stop intruders."
	button_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = "lay_web_spikes"
	background_icon_state = "bg_alien"
	overlay_icon_state = "bg_alien_border"
	check_flags = AB_CHECK_CONSCIOUS | AB_CHECK_INCAPACITATED
	cooldown_time = 40 SECONDS
	/// How long it takes to lay a web
	var/webbing_time = 3 SECONDS

/datum/action/cooldown/web_spikes/Grant(mob/grant_to)
	. = ..()
	if (!owner)
		return
	RegisterSignals(owner, list(COMSIG_MOVABLE_MOVED, COMSIG_DO_AFTER_BEGAN, COMSIG_DO_AFTER_ENDED), PROC_REF(update_status_on_signal))

/datum/action/cooldown/web_spikes/Remove(mob/removed_from)
	. = ..()
	UnregisterSignal(removed_from, list(COMSIG_MOVABLE_MOVED, COMSIG_DO_AFTER_BEGAN, COMSIG_DO_AFTER_ENDED))

/datum/action/cooldown/web_spikes/IsAvailable(feedback = FALSE)
	. = ..()
	if(!.)
		return FALSE
	if(DOING_INTERACTION(owner, DOAFTER_SOURCE_SPIDER))
		if (feedback)
			owner.balloon_alert(owner, "busy!")
		return FALSE
	if(!isturf(owner.loc))
		if (feedback)
			owner.balloon_alert(owner, "invalid location!")
		return FALSE
	if(obstructed_by_other_web_spikes())
		if (feedback)
			owner.balloon_alert(owner, "already webbed!")
		return FALSE
	return TRUE

/// Returns true if there's a web we can't put stuff on in our turf
/datum/action/cooldown/web_spikes/proc/obstructed_by_other_web_spikes()
	return !!(locate(/obj/structure/spider/spikes) in get_turf(owner))

/datum/action/cooldown/web_spikes/Activate()
	. = ..()
	var/turf/spider_turf = get_turf(owner)
	var/obj/structure/spider/webspikes = locate() in spider_turf
	if(webspikes)
		owner.balloon_alert_to_viewers("sealing web...")
	else
		owner.balloon_alert_to_viewers("spinning web...")

	if(do_after(owner, webbing_time, target = spider_turf, interaction_key = DOAFTER_SOURCE_SPIDER) && owner.loc == spider_turf)
		plant_webspikes(spider_turf, webspikes)
	else
		owner?.balloon_alert(owner, "interrupted!") // Null check because we might have been interrupted via being disintegrated
	build_all_button_icons()

/// Creates a web in the current turf
/datum/action/cooldown/web_spikes/proc/plant_webspikes(turf/target_turf, obj/structure/spider/spikes/existing_web)
	new /obj/structure/spider/spikes(target_turf)
