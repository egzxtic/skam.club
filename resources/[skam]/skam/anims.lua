Anims = {}
Anims['anims'] = {
    Animations = {
        {
            name = 'Wyrazy twarzy',
            label = 'Wyrazy twarzy',
            items = {
                {label = "Neutralny", type = "faceExpression", data = {anim = "mood_Normal_1", e = "neutralny"}},
                {label = "Szczęśliwy", type = "faceExpression", data = {anim = "mood_Happy_1", e = "szczesliwy"}},
                {label = "Zły", type = "faceExpression", data = {anim = "mood_Angry_1", e = "zly"}},		
                {label = "Podejrzliwy", type = "faceExpression", data = {anim = "mood_Aiming_1", e = "podejrzliwy"}},
                {label = "Ból", type = "faceExpression", data = {anim = "mood_Injured_1", e = "bol"}},
                {label = "Zdenerwowany", type = "faceExpression", data = {anim = "mood_stressed_1", e = "zdenerwowany"}},
                {label = "Zadowolony", type = "faceExpression", data = {anim = "mood_smug_1", e = "zadowolony"}},
                {label = "Podpity", type = "faceExpression", data = {anim = "mood_drunk_1", e = "podpity"}},
                {label = "Zszokowany", type = "faceExpression", data = {anim = "shocked_1", e = "zszokowany"}},
                {label = "Zamknięte oczy", type = "faceExpression", data = {anim = "mood_sleeping_1", e = "oczy"}},
                {label = "Przeżuwanie", type = "faceExpression", data = {anim = "eating_1", e = "zucie"}},
            }
        },

        {
            name = 'Przywitania',
            label = 'Przywitania',
            items = {
                {label = "Machanie ręką", type = "anim", data = {lib = "random@hitch_lift", anim = "come_here_idle_c", loop = 51, e = "machanie"}},
                {label = "Machanie ręką 2", type = "anim", data = {lib = "friends@fra@ig_1", anim = "over_here_idle_a", loop = 51, e = "machanie2"}},
                {label = "Machnięcie ręką 3", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_hello", loop = 50, e = "machanie3"}},
                {label = "Machnięcie ręką 4", type = "anim", data = {lib = "friends@frj@ig_1", anim = "wave_a", loop = 50, e = "machanie4"}},
                {label = "Machnięcie rękoma", type = "anim", data = {lib = "random@mugging5", anim = "001445_01_gangintimidation_1_female_idle_b", loop = 50, e = "machanie5"}},
                {label = "Machnięcie rękoma 2", type = "anim", data = {lib = "friends@frj@ig_1", anim = "wave_b", loop = 50, e = "machanie6"}},
                {label = "Machnięcie rękoma 3", type = "anim", data = {lib = "friends@frj@ig_1", anim = "wave_d", loop = 50, e = "machanie7"}},
                {label = "Żółwik", type = "anim", data = {lib = "anim@am_hold_up@male", anim = "shoplift_high", loop = 50, e = "zolwik"}},
                {label = "Graba", type = "anim", data = {lib = "mp_ped_interaction", anim = "handshake_guy_a", loop = 1, e = "graba"}},
                {label = "Piąteczka", type = "anim", data = {lib = "anim@arena@celeb@flat@paired@no_props@", anim = "high_five_c_player_b", loop = 50, e = "piateczka"}},            
            }
        },
        
        {
            name = 'Reakcje',
            label = 'Reakcje',
            items = {
                {label = "Facepalm 1", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@face_palm", anim = "face_palm", loop = 56, e = "facepalm"}},      
                {label = "Facepalm 2", type = "anim", data = {lib = "anim@mp_player_intupperface_palm", anim = "enter", loop = 50, e = "facepalm2"}},   
                {label = "Nie wierze", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@face_palm", anim = "face_palm", loop = 56, e = "niewierze"}},
                {label = "Złapanie się za głowę", type = "anim", data = {lib = "mini@dartsoutro", anim = "darts_outro_01_guy2", loop = 56, e = "zaglowe"}},			
                {label = "Tak", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_pleased", loop = 57, e = "tak"}},
                {label = "Nie", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_head_no", loop = 57, e = "nie"}},
                {label = "Nie 2", type = "anim", data = {lib = "anim@heists@ornate_bank@chat_manager", anim = "fail", loop = 57, e = "nie2"}},
                {label = "Nie ma mowy", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_no_way", loop = 56, e = "niemamowy"}},
                {label = "Wzruszenie ramionami", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_shrug_hard", loop = 56, e = "wzruszenie"}},
                {label = "Wzruszenie ramionami 2", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_shrug_hard", loop = 56, e = "wzruszenie2"}},
                {label = "Chodź tu", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_come_here_soft", loop = 57, e = "chodz"}},
                {label = "Chodź tu 2", type = "anim", data = {lib = "misscommon@response", anim = "bring_it_on", loop = 57, e = "chodz2"}},
                {label = "Chodź tu 3", type = "anim", data = {lib = "mini@triathlon", anim = "want_some_of_this", loop = 57, e = "chodz3"}},
                {label = "Co?", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_what_hard", loop = 56, e = "co"}},
                {label = "Szlag!", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_damn", loop = 56, e = "szlag"}},
                {label = "Cicho!", type = "anim", data = {lib = "anim@mp_player_intuppershush", anim = "idle_a_fp", loop = 58, e = "cicho"}},	           
                {label = "Halo!", type = "anim", data = {lib = "friends@frj@ig_1", anim = "wave_d", loop = 56, e = "halo"}},
                {label = "Tu jestem!", type = "anim", data = {lib = "friends@frj@ig_1", anim = "wave_c", loop = 56, e = "tujestem"}},
                {label = "To nie ja", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "taunt_b_player_a", loop = 0, e = "tonieja"}},		
                {label = "Przepraszam", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "wow_a_player_b", loop = 0, e = "przepraszam"}},		  
                {label = "Kciuki w górę", type = "anim", data = {lib = "anim@mp_player_intincarthumbs_upbodhi@ps@", anim = "enter", loop = 58, e = "kciuk"}},
                {label = "Kciuk w górę", type = "anim", data = {lib = "anim@mp_player_intincarthumbs_uplow@ds@", anim = "idle_a", loop = 58, e = "kciuk2"}},
                {label = "Kciuk w dół", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "thumbs_down_a_player_b", loop = 0, e = "kciuk3"}},
                {label = "Kciuk jednak w dół", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "thumbs_down_a_player_a", loop = 0, e = "kciuk4"}},			   
                {label = "Uspokój się", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_easy_now", loop = 56, e = "spokojnie"}},   
                {label = "Brawa 1", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "angry_clap_a_player_a", loop = 0, e = "brawa"}},
                {label = "Brawa 2", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "angry_clap_b_player_a", loop = 0, e = "brawa2"}},
                {label = "Brawa 3", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "angry_clap_b_player_b", loop = 0, e = "brawa3"}},
                {label = "Cieszynka", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "jump_a_player_a", loop = 50, e = "cieszynka"}},
                {label = "Zwycięzca 1", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "dance_b_1st", loop = 50, e = "zwyciezca"}},
                {label = "Zwycięzca 2", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "make_noise_a_1st", loop = 50, e = "zwyciezca2"}},
                {label = "Głowa w dół", type = "anim", data = {lib = "mp_sleep", anim = "sleep_intro", loop = 58, e = "glowadol"}},
                {label = "Znudzenie", type = "anim", data = {lib = "friends@fra@ig_1", anim = "base_idle", loop = 56, e = "znudzenie"}},
                {label = "Ukłon", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "regal_c_1st", loop = 51, e = "uklon"}},
                {label = "Ukłon 2", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "regal_a_1st", loop = 51, e = "uklon2"}},
                {label = "Zmęczony", type = "anim", data = {lib = "re@construction", anim = "out_of_breath", loop = 1, e = "zmeczony"}},
                {label = "Kaszel", type = "anim", data = {lib = "timetable@gardener@smoking_joint", anim = "idle_cough", loop = 51, e = "kaszel"}},
                {label = "Śmianie się", type = "anim", data = {lib = "anim@arena@celeb@flat@paired@no_props@", anim = "laugh_a_player_b", loop = 1, e = "smianiesie"}}, 
                {label = "Śmianie się 2", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "giggle_a_player_b", loop = 1, e = "smianiesie2"}},
                {label = "Przestraszony", type = "anim", data = {lib = "random@domestic", anim = "f_distressed_loop", loop = 1, e = "przestraszony"}},         
            }
        },
        
        {
            name = 'Postawa',
            label = 'Pozy',
            items = {
                {label = "Ochroniarz 1", type = "scenario", data = {anim = "WORLD_HUMAN_GUARD_STAND", loop = 0, e = "ochroniarz"}},
                {label = "Ochroniarz 2", type = "anim", data = {lib = "amb@world_human_stand_guard@male@base", anim = "base", loop = 51, e = "ochroniarz2"}},
                {label = "Ochroniarz 3", type = "anim", data = {lib = "mini@strip_club@idles@bouncer@stop", anim = "stop", loop = 56, e = "ochroniarz3"}},
                {label = "Policjant 1", type = "scenario", data = {anim = "WORLD_HUMAN_COP_IDLES", loop = 1, e = "policjant"}},
                {label = "Policjant 2", type = "anim", data = {lib = "amb@world_human_cop_idles@male@base", anim = "base", loop = 51, e = "policjant2"}},
                {label = "Policjant 3", type = "anim", data = {lib = "amb@world_human_cop_idles@female@base", anim = "base", loop = 51, e = "policjant3"}},
                {label = "Wypadek 1 - lewy bok", type = "anim", data = {lib = "missheist_jewel", anim = "gassed_npc_customer4", loop = 1, e = "wypadek"}},
                {label = "Wypadek 2 - prawy bok", type = "anim", data = {lib = "missheist_jewel", anim = "gassed_npc_guard", loop = 1, e = "wypadek2"}},
                {label = "Ręce do tyłu", type = "anim", data = {lib = "anim@miss@low@fin@vagos@", anim = "idle_ped06", loop = 49, e = "receztylu"}},
                {label = "Założone ręce 1", type = "anim", data = {lib = "mini@hookers_sp", anim = "idle_reject_loop_c", loop = 57, e = "rece"}},
                {label = "Założone ręce 2", type = "anim", data = {lib = "anim@amb@nightclub@peds@", anim = "rcmme_amanda1_stand_loop_cop", loop = 51, e = "rece2"}},
                {label = "Założone ręce 3", type = "anim", data = {lib = "amb@world_human_hang_out_street@female_arms_crossed@base", anim = "base", loop =51, e = "rece3"}},
                {label = "Założone ręce 4", type = "anim", data = {lib = "anim@heists@heist_corona@single_team", anim = "single_team_loop_boss", loop = 51, e = "rece4"}},
                {label = "Założone ręce 5", type = "anim", data = {lib = "random@street_race", anim = "_car_b_lookout", loop =51, e = "rece5"}},
                {label = "Założone ręce 6", type = "anim", data = {lib = "rcmnigel1a_band_groupies", anim = "base_m2", loop = 51, e = "rece6"}},
                {label = "Ręce na biodrach", type = "anim", data = {lib = "random@shop_tattoo", anim = "_idle", loop = 50, e = "biodra"}},
                {label = "Ręce na biodrach 2", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "regal_c_3rd", loop = 50, e = "biodra2"}},
                {label = "Ręka na biodrze", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "shrug_off_a_1st", loop = 50, e = "biodra3"}},
                {label = "Ręka na biodrze 2", type = "anim", data = {lib = "rcmnigel1cnmt_1c", anim = "base", loop = 51, e = "biodra4"}},
                {label = "Obejmowanie", type = "anim", data = {lib = "anim@arena@celeb@flat@paired@no_props@", anim = "this_guy_b_player_a", loop = 50, e = "obejmowanie"}},
                {label = "Obejmowanie 2", type = "anim", data = {lib = "anim@arena@celeb@flat@paired@no_props@", anim = "this_guy_b_player_b", loop = 50, e = "obejmowanie2"}},
                {label = "Poddanie się 1 - na kolanach", type = "anim", data = {lib = "random@arrests@busted", anim = "idle_a", loop = 1, e = "poddanie"}},
                {label = "Poddanie się 2 ", type = "anim", data = {lib = "anim@move_hostages@male", anim = "male_idle", loop = 51, e = "poddanie2"}},
                {label = "Poddanie się 3", type = "anim", data = {lib = "anim@move_hostages@female", anim = "female_idle", loop = 51, e = "poddanie3"}},
                {label = "Niecierpliwosc", type = "anim", data = {lib = "rcmme_tracey1", anim = "nervous_loop", loop = 51, e = "niecierpliwosc"}},
                {label = "Zastanowienie", type = "anim", data = {lib = "amb@world_human_prostitute@cokehead@base", anim = "base", loop = 1, e = "zastanowienie"}},
                {label = "Drążenie butem", type = "anim", data = {lib = "anim@mp_freemode_return@f@idle", anim = "idle_c", loop = 1, e = "drazenie"}},
                {label = "Myślenie", type = "anim", data = {lib = "rcmnigel3_idles", anim = "base_nig", loop = 51, e = "myslenie"}},
                {label = "Myślenie 2", type = "anim", data = {lib = "misscarsteal4@aliens", anim = "rehearsal_base_idle_director", loop = 51, e = "myslenie2"}},
                {label = "Myślenie 3", type = "anim", data = {lib = "timetable@tracy@ig_8@base", anim = "base", loop = 51, e = "myslenie3"}},
                {label = "Myślenie 4", type = "anim", data = {lib = "missheist_jewelleadinout", anim = "jh_int_outro_loop_a", loop = 51, e = "myslenie4"}},
                {label = "Myślenie 5", type = "anim", data = {lib = "mp_cp_stolen_tut", anim = "b_think", loop = 51, e = "myslenie5"}},
                {label = "Superbohater", type = "anim", data = {lib = "rcmbarry", anim = "base", loop = 51, e = "superbohater"}},
                {label = "Znak V", type = "anim", data = {lib = "anim@mp_player_intupperpeace", anim = "idle_a", loop = 51, e = "znakv"}},
            }
        },

        {
            name = 'siedzenie',
            label = 'Siedzenie/Lezenie/Opieranie',
            items = {
                {label = "Siedzenie 1 - na krześle", type = "scenario", data = {anim = "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", e = "siedzenie"}},	  
                {label = "Siedzenie 2 - na kanapie", type = "anim", data = {lib = "timetable@ron@ig_3_couch", anim = "base", loop = 1, e = "siedzenie2"}},		
                {label = "Siedzenie 3 - na ziemi", type = "anim", data = {lib = "anim@heists@fleeca_bank@ig_7_jetski_owner", anim = "owner_idle", loop = 1, e = "siedzenie3"}},
                {label = "Siedzenie 4 - na pikniku", type = "anim", data = {lib = "amb@world_human_picnic@female@base", anim = "base", loop = 1, e = "siedzenie4"}},
                {label = "Siedzenie 5", type = "anim", data = {lib = "timetable@jimmy@mics3_ig_15@", anim = "idle_a_jimmy", loop = 1, e = "siedzenie5"}},
                {label = "Siedzenie 6 - przecholone", type = "anim", data = {lib = "timetable@amanda@ig_7", anim = "base", loop = 1, e = "siedzenie6"}},
                {label = "Siedzenie 7 - przecholone2", type = "anim", data = {lib = "timetable@tracy@ig_14@", anim = "ig_14_base_tracy", loop = 1, e = "siedzenie7"}},
                {label = "Siedzenie 8 - noga na noge", type = "anim", data = {lib = "timetable@reunited@ig_10", anim = "base_amanda", loop = 1, e = "siedzenie8"}},
                {label = "Siedzenie 9 - załamany", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@lo_alone@", anim = "lowalone_base_laz", loop = 1, e = "siedzenie9"}},
                {label = "Siedzenie 10 - na luzie", type = "anim", data = {lib = "timetable@jimmy@mics3_ig_15@", anim = "mics3_15_base_jimmy", loop = 1, e = "siedzenie10"}},
                {label = "Siedzenie 11 - na luzie 2", type = "anim", data = {lib = "amb@world_human_stupor@male@idle_a", anim = "idle_a", loop = 1, e = "siedzenie11"}},
                {label = "Siedzenie 12 - smutny", type = "anim", data = {lib = "anim@amb@business@bgen@bgen_no_work@", anim = "sit_phone_phoneputdown_sleeping-noworkfemale", loop = 1, e = "siedzenie12"}},
                {label = "Siedzenie 13 - przestraszony", type = "anim", data = {lib = "anim@heists@ornate_bank@hostages@hit", anim = "hit_loop_ped_b", loop = 1, e = "siedzenie13"}},
                {label = "Siedzenie 14 - przestraszony 2", type = "anim", data = {lib = "anim@heists@ornate_bank@hostages@ped_c@", anim = "flinch_loop", loop = 1, e = "siedzenie14"}},
                {label = "Siedzenie 15 - dłoń na dłoni", type = "anim", data = {lib = "timetable@reunited@ig_10", anim = "base_jimmy", loop = 1, e = "siedzenie15"}},
                {label = "Siedzenie 16 - na krześle 2", type = "anim", data = {lib = "timetable@ron@ig_5_p3", anim = "ig_5_p3_base", loop = 1, e = "siedzenie16"}},
                {label = "Siedzenie 17 - na krześle 3", type = "anim", data = {lib = "timetable@maid@couch@", anim = "base", loop = 1, e = "siedzenie17"}}, 
                {label = "Siedzenie 18 - na krześle 4", type = "anim", data = {lib = "timetable@jimmy@mics3_ig_15@", anim = "mics3_15_base_tracy", loop = 1, e = "siedzenie18"}},
                {label = "Siedzenie 19 - na sofie", type = "anim", data = {lib = "timetable@trevor@smoking_meth@base", anim = "base", loop = 1, e = "siedzenie19"}},
                {label = "Siedzenie 20 - na sofie 2", type = "anim", data = {lib = "timetable@michael@on_sofabase", anim = "sit_sofa_base", loop = 1, e = "siedzenie20"}},
                {label = "Leżenie 1 - na brzuchu", type = "scenario", data = {anim = "WORLD_HUMAN_SUNBATHE", loop = 1, e = "lezenie"}},
                {label = "Leżenie 2 - na brzuchu 2", type = "anim", data = {lib = "missfbi3_sniping", anim = "prone_dave", loop = 1, e = "lezenie2"}},
                {label = "Leżenie 3 - na plecach", type = "scenario", data = {anim = "WORLD_HUMAN_SUNBATHE_BACK", loop = 0, e = "lezenie3"}},
                {label = "Leżenie 4 - na kanapie", type = "anim", data = {lib = "timetable@ron@ig_3_couch", anim = "laying", loop = 1, e = "lezenie4"}},
                {label = "Leżenie 5 - lewy bok", type = "anim", data = {lib = "amb@world_human_bum_slumped@male@laying_on_left_side@base", anim = "base", loop = 1, e = "lezenie5"}},
                {label = "Leżenie 6 - prawy bok", type = "anim", data = {lib = "amb@world_human_bum_slumped@male@laying_on_right_side@base", anim = "base", loop = 1, e = "lezenie6"}},
                {label = "Leżenie 6 - prawy bok 2", type = "anim", data = {lib = "switch@trevor@scares_tramp", anim = "trev_scares_tramp_idle_tramp", loop = 1, e = "lezenie7"}},
                {label = "Leżenie 7 - patrzenie w góre", type = "anim", data = {lib = "switch@trevor@annoys_sunbathers", anim = "trev_annoys_sunbathers_loop_girl", loop = 1, e = "lezenie8"}},
                {label = "Leżenie 8 - patrzenie w góre 2", type = "anim", data = {lib = "switch@trevor@annoys_sunbathers", anim = "trev_annoys_sunbathers_loop_guy", loop = 1, e = "lezenie9"}},
                {label = "Opieranie o barierkę 1 - przód", type = "anim", data = {lib = "amb@prop_human_bum_shopping_cart@male@base", anim = "base", loop = 1, e = "opieranie"}},
                {label = "Opieranie o barierkę 2 - przód", type = "anim", data = {lib = "missheistdockssetup1ig_12@base", anim = "talk_gantry_idle_base_worker2", loop = 1, e = "opieranie2"}},
                {label = "Opieranie o barierkę 3 - przód", type = "anim", data = {lib = "misshair_shop@hair_dressers", anim = "assistant_base", loop = 1, e = "opieranie3"}},
                {label = "Opieranie o barierkę 4 - z tyłu", type = "anim", data = {lib = "anim@amb@clubhouse@bar@bartender@", anim = "base_bartender", loop = 1, e = "opieranie4"}},
                {label = "Opieranie o stół 1 - przód", type = "anim", data = {lib = "anim@amb@clubhouse@bar@drink@base", anim = "idle_a", loop = 1, e = "opieranie5"}},
                {label = "Opieranie o stół 2 - przód", type = "anim", data = {lib = "anim@amb@board_room@diagram_blueprints@", anim = "base_amy_skater_01", loop = 1, e = "opieranie6"}},
                {label = "Opieranie o stół 3 - przód", type = "anim", data = {lib = "anim@amb@facility@missle_controlroom@", anim = "idle", loop = 1, e = "opieranie7"}},
                {label = "Opieranie ściana 1 - nogi na ziemi", type = "anim", data = {lib = "amb@world_human_leaning@male@wall@back@hands_together@base", anim = "base", loop = 1, e = "opieranie8"}},
                {label = "Opieranie ściana 2 - noga w górze", type = "anim", data = {lib = "amb@world_human_leaning@male@wall@back@foot_up@base", anim = "base", loop = 1, e = "opieranie9"}},
                {label = "Opieranie ściana 3 - nogi na krzyż", type = "anim", data = {lib = "amb@world_human_leaning@male@wall@back@legs_crossed@base", anim = "base", loop = 1, e = "opieranie10"}},
                {label = "Opieranie ściana 4 - nogi na krzyż 2", type = "anim", data = {lib = "amb@world_human_leaning@female@wall@back@holding_elbow@idle_a", anim = "idle_a", loop = 1, e = "opieranie11"}},
                {label = "Opieranie ściana 5 - głowa w dół", type = "anim", data = {lib = "anim@amb@business@bgen@bgen_no_work@", anim = "stand_phone_phoneputdown_sleeping_nowork", loop = 1, e = "opieranie12"}},
                {label = "Opieranie łokciem 1", type = "anim", data = {lib = "rcmjosh2", anim = "josh_2_intp1_base", loop = 1, e = "opieranie13"}},
                {label = "Opieranie łokciem 2", type = "anim", data = {lib = "timetable@mime@01_gc", anim = "idle_a", loop = 1, e = "opieranie14"}},
                {label = "Opieranie łokciem 3", type = "anim", data = {lib = "misscarstealfinalecar_5_ig_1", anim = "waitloop_lamar", loop = 1, e = "opieranie15"}},
                {label = "Opieranie ręką", type = "anim", data = {lib = "misscarstealfinale", anim = "packer_idle_1_trevor", loop = 1, e = "opieranie16"}},
                {label = "Zimny łokieć [Kierowca]", type = "anim", data = {lib = "anim@veh@lowrider@low@front_ds@arm@base", anim = "sit", loop = 51, e = "zimnylokiec"}},
            }
        },
        
        {
            name = 'Czynności',
            label = 'Czynności',
            items = {
                {label = "Telefon 1", type = "scenario", data = {anim = "world_human_tourist_mobile", loop = 0, e = "telefon"}},
                {label = "Telefon 2", type = "scenario", data = {anim = "WORLD_HUMAN_MOBILE_FILM_SHOCKING", loop = 0, e = "telefon2"}},
                {label = "Fotka - wyimaginowany aparat", type = "anim", data = {lib = "anim@mp_player_intincarphotographylow@ds@", anim = "idle_a", loop = 1, e = "fotka"}},
                {label = "Tłumaczenie", type = "anim", data = {lib = "misscarsteal4@actor", anim = "actor_berating_assistant", loop = 56, e = "tlumaczenie"}},
                {label = "Przyglądanie się broni", type = "anim", data = {lib = "mp_corona@single_team", anim = "single_team_intro_one", loop = 56, e = "bron"}},
                {label = "Zerkanie na zegarek", type = "anim", data = {lib = "oddjobs@taxi@", anim = "idle_a", loop = 56, e = "zegarek"}},
                {label = "Czyszczenie 1 - mycie ścierką", type = "scenario", data = {anim = "world_human_maid_clean", loop = 0, e = "mycie"}},
                {label = "Czyszczenie 2 - mycie maski auta", type = "anim", data = {lib = "switch@franklin@cleaning_car", anim = "001946_01_gc_fras_v2_ig_5_base", loop = 1, e = "mycie2"}},
                {label = "Branie prysznica 1", type = "anim", data = {lib = "mp_safehouseshower@female@", anim = "shower_idle_a", loop = 1, e = "prysznic"}},
                {label = "Branie prysznica 2", type = "anim", data = {lib = "mp_safehouseshower@male@", anim = "male_shower_idle_a", loop = 1, e = "prysznic2"}},
                {label = "Branie prysznica 3", type = "anim", data = {lib = "mp_safehouseshower@male@", anim = "male_shower_idle_d", loop = 1, e = "prysznic3"}},
                {label = "Sięganie do schowka w aucie [Pojazd]", type = "animschowek", data = {lib = "rcmme_amanda1", anim = "drive_mic", loop = 56, e = "schowek"}},
                {label = "Włamywanie do sejfu", type = "anim", data = {lib = "mini@safe_cracking", anim = "dial_turn_anti_normal", loop = 0, e = "sejf"}},
                {label = "Przymierzanie ubrań", type = "anim", data = {lib = "mp_clothing@female@trousers", anim = "try_trousers_neutral_a", loop = 1, e = "ubrania"}},
                {label = "Przymierzanie góry", type = "anim", data = {lib = "mp_clothing@female@shirt", anim = "try_shirt_positive_a", loop = 1, e = "ubrani2"}},
                {label = "Przymierzanie butów", type = "anim", data = {lib = "mp_clothing@female@shoes", anim = "try_shoes_positive_a", loop = 1, e = "ubrania3"}},
                {label = "Pakowanie do torby", type = "anim", data = {lib = "anim@heists@ornate_bank@grab_cash", anim = "grab", loop = 1, e = "torba"}},
                {label = "Oddawaj pieniądze", type = "anim", data = {lib = "mini@prostitutespimp_demands_money", anim = "pimp_demands_money_pimp", loop = 0, e = "oddawaj"}},
                {label = "Samobójstwo", type = "anim", data = {lib = "mp_suicide", anim = "pistol", loop = 2, e = "samobojstwo"}},
                {label = "Salutowanie", type = "anim", data = {lib = "mp_player_int_uppersalute", anim = "mp_player_int_salute", loop = 51, e = "salut"}},
                {label = "Kłótnia", type = "anim", data = {lib = "sdrm_mcs_2-0", anim = "csb_bride_dual-0", loop = 56, e = "klotnia"}},
                {label = "Kucanie", type = "anim", data = {lib = "rcmextreme3", anim = "idle", loop = 1, e = "kucanie"}},
                {label = "Kucanie 2", type = "anim", data = {lib = "amb@world_human_bum_wash@male@low@idle_a", anim = "idle_a", loop = 1, e = "kucanie2"}},
                {label = "Gwizdanie", type = "anim", data = {lib = "rcmnigel1c", anim = "hailing_whistle_waive_a", loop = 51, e = "gwizdanie"}},
                {label = "Gwizdanie 2", type = "anim", data = {lib = "taxi_hail", anim = "hail_taxi", loop = 51, e = "gwizdanie2"}},
                {label = "Celowanie", type = "anim", data = {lib = "random@countryside_gang_fight", anim = "biker_02_stickup_loop", loop = 49, e = "celowanie"}},
                {label = "Celowanie 2", type = "anim", data = {lib = "random@atmrobberygen", anim = "b_atm_mugging", loop = 49, e = "celowanie2"}},
                {label = "Celowanie 3", type = "anim", data = {lib = "move_weapon@pistol@copa", anim = "idle", loop = 49, e = "celowanie3"}},
                {label = "Celowanie 4", type = "anim", data = {lib = "move_weapon@pistol@cope", anim = "idle", loop = 49, e = "celowanie4"}},
                {label = "Celowanie 5", type = "anim", data = {lib = "combat@aim_variations@1h@gang", anim = "aim_variation_b", loop = 51, e = "celowanie5"}},
                {label = "Medytacja", type = "anim", data = {lib = "rcmcollect_paperleadinout@", anim = "meditiate_idle", loop = 1, e = "medytacja"}},
                {label = "Medytacja 2", type = "anim", data = {lib = "rcmepsilonism3", anim = "ep_3_rcm_marnie_meditating", loop = 1, e = "medytacja2"}},
                {label = "Pukanie", type = "anim", data = {lib = "timetable@jimmy@doorknock@", anim = "knockdoor_idle", loop = 51, e = "pukanie"}},
                {label = "Wskazywanie", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_point", loop = 56, e = "wskazywanie"}},
                {label = "Wskazywanie 2 - Dół", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_hand_down", loop = 56, e = "wskazywanie2"}},
                {label = "Wskazywanie 3 - Prawo", type = "anim", data = {lib = "mp_gun_shop_tut", anim = "indicate_right", loop = 56, e = "wskazywanie3"}},
                {label = "Trzymanie się za kabure", type = "anim", data = {lib = "move_m@intimidation@cop@unarmed", anim = "idle", loop = 49, e = "kabura"}},
                {label = "Granie w golfa", type = "anim", data = {lib = "rcmnigel1d", anim = "swing_a_mark", loop = 51, e = "golf"}},  
            }	
        },
        
        {
            name = 'Chamskie',
            label = 'Chamskie',
            items = {
                {label = "Mów do ręki", type = "anim", data = {lib = "mini@prostitutestalk", anim = "street_argue_f_a", loop = 56, e = ""}},           
                {label = "Środkowy palec 1", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "flip_off_a_1st", loop = 56, e = "palec"}},
                {label = "Środkowy palec 2 - z kieszeni", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "flip_off_b_1st", loop = 56, e = "palec2"}},
                {label = "Środkowy palec 3", type = "anim", data = {lib = "anim@mp_player_intselfiethe_bird", anim = "idle_a", loop = 51, e = "palec3"}},
                {label = "Pokazywanie środkowych palców", type = "anim", data = {lib = "mp_player_int_upperfinger", anim = "mp_player_int_finger_01_enter", loop = 58, e = "palec4"}},
                {label = "Sarkastyczne klaskanie 1", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@slow_clap", anim = "slow_clap", loop = 56, e = "klaskanie"}},
                {label = "Sarkastyczne klaskanie 2", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@slow_clap", anim = "slow_clap", loop = 56, e = "klaskanie2"}},
                {label = "Sarkastyczne klaskanie 3", type = "anim", data = {lib = "anim@mp_player_intupperslow_clap", anim = "idle_a", loop = 57, e = "klaskanie3"}},
                {label = "Sarkastyczne klaskanie 4", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "regal_b_3rd", loop = 0, e = "klaskanie4"}},          
                {label = "Drapanie sie po kroczu", type = "anim", data = {lib = "mp_player_int_uppergrab_crotch", anim = "mp_player_int_grab_crotch", loop = 57, e = "drapaniepokroczu"}},
                {label = "Dłubanie w nosie - strzał gilem", type = "anim", data = {lib = "anim@mp_player_intuppernose_pick", anim = "exit", loop = 56, e = "dlubanie"}},
                {label = "Dłubanie w nosie 2 - oscentacyjne", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@nose_pick", anim = "nose_pick", loop = 0, e = "dlubanie2"}},
                {label = "Ten z tyłu śmierdzi", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "taunt_c_player_b", loop = 0, e = "smierdzi"}},
                {label = "No dawaj!", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_bring_it_on", loop = 56, e = "dawaj"}},
                {label = "Gotowość na bójkę", type = "anim", data = {lib = "anim@mp_player_intupperknuckle_crunch", anim = "idle_a", loop = 56, e = "bojka"}},
                {label = "Gotowość na bójkę 2", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@knuckle_crunch", anim = "knuckle_crunch", loop = 56, e = "bojka2"}},
                {label = "Gotowość na bójkę 3", type = "anim", data = {lib = "anim@deathmatch_intros@unarmed", anim = "intro_male_unarmed_c", loop = 1, e = "bojka3"}},           
                {label = "Gotowość na bójkę 4", type = "anim", data = {lib = "anim@deathmatch_intros@unarmed", anim = "intro_male_unarmed_e", loop = 1, e = "bojka4"}},           
                {label = "Spoliczkowanie", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "air_slap_a_1st", loop = 56, e = "policzek"}},
            }
        },
        
        {
            name = 'Sportowe',
            label = 'Sportowe',
            items = {
                {label = "Jogging", type = "anim", data = {lib = "move_m@jogger", anim = "run", loop = 33, e = "jogging"}},
                {label = "Jogging 2", type = "scenario", data = {anim = "WORLD_HUMAN_JOG_STANDING", loop = 0, e = "jogging2"}},
                {label = "Trucht", type = "anim", data = {lib = "move_m@jog@", anim = "run", loop = 33, e = "trucht"}},
                {label = "Powerwalk", type = "anim", data = {lib = "amb@world_human_power_walker@female@base", anim = "base", loop = 33, e = "powerwalk"}},
                {label = "Napinanie mięśni", type = "anim", data = {lib = "amb@world_human_muscle_flex@arms_at_side@base", anim = "base", loop = 1, e = "napinanie"}},
                {label = "Pompki", type = "anim", data = {lib = "amb@world_human_push_ups@male@base", anim = "base", loop = 1, e = "pompki"}},
                {label = "Brzuszki", type = "anim", data = {lib = "amb@world_human_sit_ups@male@base", anim = "base", loop = 1, e = "brzuszki"}},
                {label = "Salto w tył", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "flip_a_player_a", loop = 0, e = "salto"}},
                {label = "Capoeira", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "cap_a_player_a", loop = 0, e = "capoeira"}},
                {label = "Yoga 1 - przygotowanie", type = "anim", data = {lib = "amb@world_human_yoga@male@base", anim = "base", loop = 1, e = "yoga"}},
                {label = "Yoga 2 - rozciąganie się", type = "anim", data = {lib = "amb@world_human_yoga@female@base", anim = "base_b", loop = 1, e = "yoga2"}},
                {label = "Yoga 3 - stanie na rękach", type = "anim", data = {lib = "amb@world_human_yoga@female@base", anim = "base_c", loop = 1, e = "yoga3"}},
                {label = "Wślizg na kolanach", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "slide_a_player_a", loop = 0, e = "wslizg"}},
                {label = "Skok przez kozła", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "jump_b_player_a", loop = 0, e = "skok"}},
                {label = "Szpagat", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "jump_c_player_a", loop = 0, e = "szpagat"}},
                {label = "Podskok", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "jump_d_player_a", loop = 0, e = "podskok"}},
                {label = "Pajacyki", type = "anim", data = {lib = "timetable@reunited@ig_2", anim = "jimmy_masterbation", loop = 1, e = "pajacyki"}},
                {label = "Rozciąganie się", type = "anim", data = {lib = "mini@triathlon", anim = "idle_e", loop = 1, e = "rozciaganie"}},
                {label = "Rozciąganie się 2", type = "anim", data = {lib = "mini@triathlon", anim = "idle_f", loop = 1, e = "rozciaganie2"}},
                {label = "Rozciąganie się 3", type = "anim", data = {lib = "mini@triathlon", anim = "idle_d", loop = 1, e = "rozciaganie3"}},
                {label = "Rozciąganie się 4", type = "anim", data = {lib = "rcmfanatic1maryann_stretchidle_b", anim = "idle_e", loop = 1, e = "rozciaganie4"}}, 
                {label = "Boks", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@shadow_boxing", anim = "shadow_boxing", loop = 51, e = "boks"}},
                {label = "Boks 2", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@shadow_boxing", anim = "shadow_boxing", loop = 51, e = "boks2"}},
                {label = "Karate", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@karate_chops", anim = "karate_chops", loop = 1, e = "karate"}},
                {label = "Karate 2", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@karate_chops", anim = "karate_chops", loop = 1, e = "karate2"}},      
            }
        },

        {
            name = 'Czynności Pracy',
            label = 'Czynności Pracy',
            items = {
                {label = "Mechanik 1 - maska", type = "anim", data = {lib = "mini@repair", anim = "fixing_a_ped", loop = 1, e = "mechanik"}},
                {label = "Mechanik 2 - maska", type = "anim", data = {lib = "mini@repair", anim = "fixing_a_player", loop = 1, e = "mechanik2"}},
                {label = "Mechanik 3 - pod autem", type = "anim", data = {lib = "amb@world_human_vehicle_mechanic@male@base", anim = "base", loop = 1, e = "mechanik3"}},
                {label = "Mechanik 4 - wyjście spod auta", type = "anim", data = {lib = "amb@world_human_vehicle_mechanic@male@exit", anim = "exit", loop = 0, e = "mechanik4"}},
                {label = "Uderzanie młotkiem", type = "scenario", data = {anim = "WORLD_HUMAN_HAMMERING", loop = 0, e = "mlotek"}},
                {label = "Spawanie", type = "scenario", data = {anim = "WORLD_HUMAN_WELDING", loop = 1, e = "spawanie"}},
                {label = "Pisanie na komputerze", type = "anim", data = {lib = "anim@heists@prison_heistig1_p1_guard_checks_bus", anim = "loop", loop = 1, e = "komputer"}},
                {label = "Ładowanie towaru", type = "anim", data = {lib = "mp_am_hold_up", anim = "purchase_beerbox_shopkeeper", loop = 0, e = "towar"}},
                {label = "Kopanie w ziemi - klękanie", type = "scenario", data = {anim = "world_human_gardener_plant", loop = 0, e = "kopanie2"}},
            }
        },

        {
            name = 'Służbowe',
            label = 'Służbowe',
            items = {
                {label = "Sprawdzanie stanu 1 - klękanie", type = "scenario", data = {anim = "CODE_HUMAN_MEDIC_KNEEL", loop = 0, e = "stan"}},
                {label = "Sprawdzanie stanu 2 - uciskanie", type = "anim", data = {lib = "anim@heists@narcotics@funding@gang_idle", anim = "gang_chatting_idle01", loop = 1, e = "stan2"}},		
                {label = "Ból w klatce piersiowej", type = "anim", data = {lib = "anim@heists@prison_heistig_5_p1_rashkovsky_idle", anim = "idle", loop = 1, e = "klatka"}},
                {label = "Ból nogi", type = "anim", data = {lib = "missfbi5ig_0", anim = "lyinginpain_loop_steve", loop = 1, e = "noga"}},
                {label = "Ból brzucha", type = "anim", data = {lib = "combat@damage@writheidle_a", anim = "writhe_idle_a", loop = 1, e = "brzuch"}},
                {label = "Ból głowy", type = "anim", data = {lib = "combat@damage@writheidle_b", anim = "writhe_idle_f", loop = 1, e = "glowa"}},
                {label = "Ból głowy 2", type = "anim", data = {lib = "misscarsteal4@actor", anim = "dazed_idle", loop = 51, e = "glowa2"}},
                {label = "Drgawki", type = "anim", data = {lib = "missheistfbi3b_ig8_2", anim = "cpr_loop_victim", loop = 1, e = "drgawki"}},
                {label = "Omdlenie 1 - prawy bok", type = "anim", data = {lib = "dam_ko@shot", anim = "ko_shot_head", loop = 2, e = "omdlenie"}},
                {label = "Omdlenie 2 - na plecy", type = "anim", data = {lib = "anim@gangops@hostage@", anim = "perp_success", loop = 2, e = "omdlenie2"}},
                {label = "Omdlenie 3 - leżąc", type = "anim", data = {lib = "mini@cpr@char_b@cpr_def", anim = "cpr_intro", loop = 2, e = "omdlenie3"}},
                {label = "Ocknięcie 1 - ponowne omdlenie", type = "anim", data = {lib = "missfam5_blackout", anim = "pass_out", loop = 2, e = "ockniecie"}},
                {label = "Ocknięcie 2 - wymiotowanie", type = "anim", data = {lib = "missfam5_blackout", anim = "vomit", loop = 0, e = "ockniecie2"}},
                {label = "Ocknięcie 3 - szybko", type = "anim", data = {lib = "safe@trevor@ig_8", anim = "ig_8_wake_up_front_player", loop = 0, e = "ockniecie3"}},
                {label = "Ocknięcie 4 - powoli", type = "anim", data = {lib = "safe@trevor@ig_8", anim = "ig_8_wake_up_right_player", loop = 0, e = "ockniecie4"}},
                {label = "Brak przytomności 1", type = "anim", data = {lib = "mini@cpr@char_b@cpr_def", anim = "cpr_pumpchest_idle", loop = 1, e = "nieprzytomnosc"}},
                {label = "Brak przytomności 2", type = "anim", data = {lib = "missprologueig_6", anim = "lying_dead_brad", loop = 1, e = "nieprzytomnosc2"}},
                {label = "Brak przytomności 3", type = "anim", data = {lib = "missprologueig_6", anim = "lying_dead_player0", loop = 1, e = "nieprzytomnosc3"}},
                {label = "Brak przytomności 4", type = "anim", data = {lib = "random@mugging4", anim = "flee_backward_loop_shopkeeper", loop = 1, e = "nieprzytomnosc4"}},
                {label = "Brak przytomności 5 - na brzuchu", type = "anim", data = {lib = "missarmenian2", anim = "drunk_loop", loop = 1, e = "nieprzytomnosc5"}},
                {label = "RKO 1 - uciskanie", type = "anim", data = {lib = "mini@cpr@char_a@cpr_str", anim = "cpr_pumpchest", loop = 1, e = "rko"}},
                {label = "RKO 2 - wdechy", type = "anim", data = {lib = "mini@cpr@char_a@cpr_str", anim = "cpr_kol", loop = 1, e = "rko2"}},
                {label = "Wzywanie SOS - rękoma", type = "anim", data = {lib = "random@gang_intimidation@", anim = "001445_01_gangintimidation_1_female_wave_loop", loop = 51, e = "sos"}},
                {label = "Sprawdzanie dowodów", type = "anim", data = {lib = "amb@code_human_police_investigate@idle_b", anim = "idle_f", loop = 0, e = "dowody"}},
                {label = "Sprawdzanie dowodów 2", type = "anim", data = {lib = "random@train_tracks", anim = "idle_e", loop = 0, e = "dowody2"}},
            }
        },

        {
            name = 'Tańce',
            label = 'Tańce',
            items = {
                {label = "Twerk", type = "anim", data = {lib = "switch@trevor@mocks_lapdance", anim = "001443_01_trvs_28_idle_stripper", loop = 1, e = "twerk"}},   
                {label = "Taniec 1", type = "anim", data = {lib = "misschinese2_crystalmazemcs1_cs", anim = "dance_loop_tao", loop = 1, e = "taniec"}},           
                {label = "Taniec 2", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^1", loop = 1, e = "taniec2"}},
                {label = "Taniec 3", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^3", loop = 1, e = "taniec3"}},
                {label = "Taniec 4", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^6", loop = 1, e = "taniec4"}},
                {label = "Taniec 5", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_female^1", loop = 1, e = "taniec5"}},
                {label = "Taniec 6", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v1_female^1", loop = 1, e = "taniec6"}},
                {label = "Taniec 7", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_podium@", anim = "danceidle_hi_11_turnaround_laz", loop = 1, e = "taniec7"}},
                {label = "Taniec 8", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_podium@", anim = "danceidle_hi_17_smackthat_laz", loop = 1, e = "taniec8"}},
                {label = "Taniec 9", type = "anim", data = {lib = "special_ped@mountain_dancer@monologue_3@monologue_3a", anim = "mnt_dnc_buttwag", loop = 1, e = "taniec9"}},
                {label = "Taniec 10", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_podium@", anim = "danceidle_hi_06_base_laz", loop = 1, e = "taniec10"}},
                {label = "Taniec 11", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@uncle_disco", anim = "uncle_disco", loop = 1, e = "taniec11"}},
                {label = "Taniec 12", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_groups_transitions@", anim = "trans_dance_crowd_hi_to_mi_09_v1_female^1", loop = 1, e = "taniec12"}},
                {label = "Taniec 13", type = "anim", data = {lib = "rcmnigel1bnmt_1b", anim = "dance_loop_tyler", loop = 1, e = "taniec13"}},
                {label = "Taniec 14", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", anim = "low_center", loop = 1, e = "taniec14"}},
                {label = "Taniec 15", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_podium@", anim = "danceidle_mi_15_robot_laz",  loop = 1, e = "taniec15"}},
                {label = "Taniec 16", type = "anim", data = {lib = "anim@amb@nightclub@dancers@solomun_entourage@", anim = "mi_dance_facedj_17_v1_female^1",  loop = 1, e = "taniec16"}},
                {label = "Taniec 17", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", anim = "high_center_up",  loop = 1, e = "taniec17"}},
                {label = "Taniec 18", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", anim = "low_center",  loop = 1, e = "taniec18"}},
                {label = "Taniec 19", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", anim = "med_center_up",  loop = 1, e = "taniec19"}},
                {label = "Taniec 20", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_female^1",  loop = 1, e = "taniec20"}},
                {label = "Taniec 21", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_female^3",  loop = 1, e = "taniec21"}},
                {label = "Taniec 22", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^3",  loop = 1, e = "taniec22"}},
                {label = "Taniec 23", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_groups_transitions@", anim = "trans_dance_crowd_hi_to_li_09_v1_female^3",  loop = 1, e = "taniec23"}},
                {label = "Taniec 24", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@thumb_on_ears", anim = "thumb_on_ears",  loop = 1, e = "taniec24"}},
                {label = "Taniec 25", type = "anim", data = {lib = "special_ped@mountain_dancer@monologue_2@monologue_2a", anim = "mnt_dnc_angel",  loop = 1, e = "taniec25"}},
                {label = "Taniec 26", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", anim = "high_center",  loop = 1, e = "taniec26"}},
                {label = "Taniec 27", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", anim = "high_center_up",  loop = 1, e = "taniec27"}},
                {label = "Taniec 28", type = "anim", data = {lib = "anim@amb@casino@mini@dance@dance_solo@female@var_b@", anim = "high_center",  loop = 1, e = "taniec28"}},
                {label = "Taniec 29", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", anim = "low_center_down",  loop = 1, e = "taniec29"}},
                {label = "Taniec 30", type = "anim", data = {lib = "timetable@tracy@ig_8@idle_b", anim = "idle_d",  loop = 1, e = "taniec30"}},
                {label = "Taniec 31", type = "anim", data = {lib = "timetable@tracy@ig_5@idle_a", anim = "idle_a",  loop = 1, e = "taniec31"}},
                {label = "Taniec 32", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_podium@", anim = "danceidle_hi_11_buttwiggle_b_laz",  loop = 1, e = "taniec32"}},
                {label = "Taniec 33", type = "anim", data = {lib = "move_clown@p_m_two_idles@", anim = "fidget_short_dance",  loop = 1, e = "taniec33"}},
                {label = "Taniec 34", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "high_center",  loop = 1, e = "taniec34"}},
                {label = "Taniec 35", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "high_center_down",  loop = 1, e = "taniec35"}},
                {label = "Taniec 36", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "med_center_down",  loop = 1, e = "taniec36"}},
                {label = "Taniec 37", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_13_v1_male^3",  loop = 1, e = "taniec37"}},
                {label = "Taniec 38", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_13_v2_male^1",  loop = 1, e = "taniec38"}},
                {label = "Taniec 39", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_17_v2_male^4",  loop = 1, e = "taniec39"}},
                {label = "Taniec 40", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_15_v2_male^4",  loop = 1, e = "taniec40"}},
                {label = "Taniec 41", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_v2_male^5",  loop = 1, e = "taniec41"}},
                {label = "Taniec 42", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "high_right_up",  loop = 1, e = "taniec42"}},
                {label = "Taniec 43", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "med_center",  loop = 1, e = "taniec43"}},
                {label = "Taniec 44", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "high_right_down",  loop = 1, e = "taniec44"}},
                {label = "Taniec 45", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_13_v2_male^1",  loop = 1, e = "taniec45"}},
                {label = "Taniec 46", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "high_left_down",  loop = 1, e = "taniec46"}},
                {label = "Taniec 47", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", anim = "low_center",  loop = 1, e = "taniec47"}},
                {label = "Taniec 48", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_paired@dance_d@", anim = "ped_a_dance_idle",  loop = 1, e = "taniec48"}},
                {label = "Taniec 49", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_paired@dance_b@", anim = "ped_a_dance_idle",  loop = 1, e = "taniec49"}},
                {label = "Taniec 50", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_paired@dance_a@", anim = "ped_a_dance_idle",  loop = 1, e = "taniec50"}},
                {label = "Taniec 51", type = "anim", data = {lib = "anim@mp_player_intuppersalsa_roll", anim = "idle_a",  loop = 1, e = "taniec51"}},
                {label = "Taniec 52", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@uncle_disco", anim = "uncle_disco",  loop = 1, e = "taniec52"}},
                {label = "Taniec 53", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_a_f02",  loop = 1, e = "taniec53"}},
                {label = "Taniec 54", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_b_m03",  loop = 1, e = "taniec54"}},
                {label = "Taniec 55", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_b_f01",  loop = 1, e = "taniec55"}},
                {label = "Taniec 56", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_a_m02",  loop = 1, e = "taniec56"}},
                {label = "Taniec 57", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_a_m05",  loop = 1, e = "taniec57"}},
                {label = "Taniec 58", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_a_m03",  loop = 1, e = "taniec58"}},
                {label = "Taniec 59", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_13_v2_male^1",  loop = 1, e = "taniec59"}},
                {label = "Taniec 60", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_d_f01",  loop = 1, e = "taniec60"}},
                {label = "Klubowy 1 (Dla kobiet)", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^1",  loop = 1, e = "klubowy1"}},
                {label = "Klubowy 2 (Dla mężczyzn)", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_male^2",  loop = 1, e = "klubowy2"}},
                {label = "Klubowy 3 (Dla kobiet)", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^3",  loop = 1, e = "klubowy3"}},
                {label = "Klubowy 4", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_podium@", anim = "danceidle_mi_17_crotchgrab_laz",  loop = 1, e = "klubowy4"}},
            }
        }, 

        {
            name = 'Imprezowe',
            label = 'Imprezowe',
            items = {
                {label = "DJ", type = "anim", data = {lib = "mini@strip_club@idles@dj@idle_02", anim = "idle_02", loop = 1, e = "dj"}},
                {label = "Oglądanie występu", type = "anim", data = {lib = "amb@world_human_strip_watch_stand@male_a@base", anim = "base", loop = 1, e = "ogladanie"}},
                {label = "Gest 1 - Ręce w górze", type = "anim", data = {lib = "mp_player_int_uppergang_sign_a", anim = "mp_player_int_gang_sign_a", loop = 57, e = "gest"}},
                {label = "Gest 2 - Znak V", type = "anim", data = {lib = "mp_player_int_upperv_sign", anim = "mp_player_int_v_sign", loop = 57, e = "gest2"}},
                {label = "Gest 3 - Znak V 2", type = "anim", data = {lib = "anim@mp_player_intupperpeace", anim = "idle_a_fp", loop = 57, e = "gest2"}},
                {label = "Gest 3 - Znak V 3", type = "anim", data = {lib = "anim@mp_player_intincarpeacebodhi@ds@", anim = "idle_a", loop = 57, e = "gest2"}},
                {label = "Bycie pijanym", type = "anim", data = {lib = "amb@world_human_bum_standing@drunk@idle_a", anim = "idle_a", loop = 1, e = "pijany"}},
                {label = "Udawanie gry na gitarze", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@air_guitar", anim = "air_guitar", loop = 0, e = "udawaniegry"}},
                {label = "Rock'n roll 1", type = "anim", data = {lib = "mp_player_int_upperrock", anim = "mp_player_int_rock_enter", loop = 56, e = "rock"}},
                {label = "Rock'n roll 2", type = "anim", data = {lib = "mp_player_introck", anim = "mp_player_int_rock", loop = 56, e = "rock2"}},           
                {label = "Rzucanie hajsem", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@props@", anim = "make_it_rain_b_player_b", loop = 0, e = "hajs"}},
                {label = "Śmiech", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "taunt_e_player_b", loop = 0, e = "smiech"}},
                {label = "Pozowanie - manekin", type = "scenario", data = {anim = "WORLD_HUMAN_HUMAN_STATUE", loop = 1, e = "manekin"}},
                {label = "Pozowanie - manekin 2", type = "anim", data = {lib = "fra_0_int-1", anim = "cs_lamardavis_dual-1", loop = 49, e = "manekin3"}},
                {label = "Pozowanie - manekin 3", type = "anim", data = {lib = "club_intro2-0", anim = "csb_englishdave_dual-0", loop = 0, e = "manekin3"}},
                {label = "Wymiotowanie w aucie", type = "anim", data = {lib = "oddjobs@taxi@tie", anim = "vomit_outside", loop = 0, e = "wymioty"}},
                {label = "Udawanie ptaka", type = "anim", data = {lib = "random@peyote@bird", anim = "wakeup", loop = 51, e = "ptak"}},
                {label = "Udawanie kurczaka", type = "anim", data = {lib = "random@peyote@chicken", anim = "wakeup", loop = 51, e = "kurczak"}},
                {label = "Udawanie królika", type = "anim", data = {lib = "random@peyote@rabbit", anim = "wakeup", loop = 1, e = "krolik"}},
                {label = "Udawanie klauna 1", type = "anim", data = {lib = "rcm_barry2", anim = "clown_idle_0", loop = 1, e = "klaun"}},           
                {label = "Udawanie klauna 2", type = "anim", data = {lib = "rcm_barry2", anim = "clown_idle_1", loop = 1, e = "klaun2"}},
                {label = "Udawanie klauna 3", type = "anim", data = {lib = "rcm_barry2", anim = "clown_idle_2", loop = 1, e = "klaun3"}},
                {label = "Udawanie klauna 4", type = "anim", data = {lib = "rcm_barry2", anim = "clown_idle_3", loop = 1, e = "klaun4"}},
                {label = "Udawanie klauna 5", type = "anim", data = {lib = "rcm_barry2", anim = "clown_idle_6", loop = 1, e = "klaun5"}},
                {label = "Kontrolowanie umysłu", type = "anim", data = {lib = "rcmbarry", anim = "mind_control_b_loop", loop = 56, e = "kontrolowanie"}},
                {label = "Kontrolowanie umysłu 2", type = "anim", data = {lib = "rcmbarry", anim = "bar_1_attack_idle_aln", loop = 56, e = "kontrolowanie2"}},
            }
        },

        {
            name = 'Miłosne',
            label = 'Miłosne',
            items = {
                {label = "Przytul 1", type = "anim", data = {lib = "mp_ped_interaction", anim = "kisses_guy_a", loop = 0, e = "przytul"}},
                {label = "Przytul 2", type = "anim", data = {lib = "mp_ped_interaction", anim = "kisses_guy_b", loop = 0, e = "przytul2"}},        	
                {label = "Całus 1", type = "anim", data = {lib = "anim@mp_player_intselfieblow_kiss", anim = "exit", loop = 56, e = "calus"}},
                {label = "Całus 2", type = "anim", data = {lib = "mini@hookers_sp", anim = "idle_a", loop = 0, e = "calus2"}},
                {label = "Całus 3", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@blow_kiss", anim = "blow_kiss", loop = 56, e = "calus3"}},
                {label = "Uroczo", type = "anim", data = {lib = "mini@hookers_spcokehead", anim = "idle_reject_loop_a", loop = 58, e = "uroczo"}},
                {label = "Zawstydzenie", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "regal_a_3rd", loop = 0, e = "zawstydzenie"}},
                {label = "Zawstydzenie 2", type = "anim", data = {lib = "amb@world_human_hang_out_street@female_hold_arm@idle_a", anim = "idle_a", loop = 51, e = "zawstydzenie2"}},          
                {label = "Uwodzenie", type = "anim", data = {lib = "mini@strip_club@idles@stripper", anim = "stripper_idle_02", loop = 1, e = "uwodzenie"}},
            }
        },

        {
            name  = 'Style chodzenia',
            label = 'Style chodzenia',
            items = {
                {label = "Normalny [K]", type = "attitude", data = {lib = "move_f@generic", anim = "move_f@generic", e = ""}},
                {label = "Normalny [M]", type = "attitude", data = {lib = "move_m@generic", anim = "move_m@generic", e = ""}},
                {label = "Pewniak [K]", type = "attitude", data = {lib = "move_f@heels@d", anim = "move_f@heels@d", e = ""}},
                {label = "Pewniak [M]", type = "attitude", data = {lib = "move_m@confident", anim = "move_m@confident", e = ""}},
                {label = "Gruby [K]", type = "attitude", data = {lib = "move_f@fat@a", anim = "move_f@fat@a", e = ""}},
                {label = "Gruby [M]", type = "attitude", data = {lib = "move_m@fat@a", anim = "move_m@fat@a", e = ""}},
                {label = "Poszkodowany [K]", type = "attitude", data = {lib = "move_f@injured", anim = "move_f@injured", e = ""}},
                {label = "Poszkodowany [M]", type = "attitude", data = {lib = "move_m@injured", anim = "move_m@injured", e = ""}},
                {label = "Policjant", type = "attitude", data = {lib = "move_m@tool_belt@a", anim = "move_m@tool_belt@a", e = ""}},
                {label = "Policjantka", type = "attitude", data = {lib = "move_f@tool_belt@a", anim = "move_f@tool_belt@a", e = ""}},
                {label = "Zuchwały [K]", type = "attitude", data = {lib = "move_f@sassy", anim = "move_f@sassy", e = ""}},
                {label = "Zuchwały [M]", type = "attitude", data = {lib = "move_m@sassy", anim = "move_m@sassy", e = ""}},
                {label = "Smutny", type = "attitude", data = {lib = "move_m@depressed@a", anim = "move_m@depressed@a", e = ""}},
                {label = "Biznes", type = "attitude", data = {lib = "move_m@business@a", anim = "move_m@business@a", e = ""}},
                {label = "Odważny", type = "attitude", data = {lib = "move_m@brave@a", anim = "move_m@brave@a", e = ""}},
                {label = "Luzak", type = "attitude", data = {lib = "move_m@casual@e", anim = "move_m@casual@e", e = ""}},
                {label = "Hipster", type = "attitude", data = {lib = "move_m@hipster@a", anim = "move_m@hipster@a", e = ""}},
                {label = "Smutny", type = "attitude", data = {lib = "move_m@sad@a", anim = "move_m@sad@a", e = ""}},
                {label = "Siłacz", type = "attitude", data = {lib = "move_m@muscle@a", anim = "move_m@muscle@a", e = ""}},
                {label = "Gangster 1", type = "attitude", data = {lib = "move_m@gangster@generic", anim = "move_m@gangster@generic", e = ""}},
                {label = "Gangster 2", type = "attitude", data = {lib = "move_m@money", anim = "move_m@money", e = ""}},
                {label = "Gangster 3", type = "attitude", data = {lib = "move_m@gangster@ng", anim = "move_m@gangster@ng", e = ""}},
                {label = "Gangster 4", type = "attitude", data = {lib = "move_m@gangster@var_e", anim = "move_m@gangster@var_e", e = ""}},
                {label = "Wspinaczka", type = "attitude", data = {lib = "move_m@hiking", anim = "move_m@hiking", e = ""}},
                {label = "Bezdomny", type = "attitude", data = {lib = "move_m@hobo@a", anim = "move_m@hobo@a", e = ""}},
                {label = "Podpity", type = "attitude", data = {lib = "move_m@buzzed", anim = "move_m@buzzed", e = ""}},
                {label = "Średnio Pijany", type = "attitude", data = {lib = "move_m@drunk@moderatedrunk", anim = "move_m@drunk@moderatedrunk", e = ""}},
                {label = "Bardzo Pijany", type = "attitude", data = {lib = "move_m@drunk@verydrunk", anim = "move_m@drunk@verydrunk", e = ""}},
                {label = "W pośpiechu 1", type = "attitude", data = {lib = "move_m@hurry_butch@b", anim = "move_m@hurry_butch@b", e = ""}},
                {label = "W pośpiechu 2", type = "attitude", data = {lib = "move_m@hurry@b", anim = "move_m@hurry@b", e = ""}},
                {label = "Szybki", type = "attitude", data = {lib = "move_m@quick", anim = "move_m@quick", e = ""}},
                {label = "Dziwny", type = "attitude", data = {lib = "move_m@alien", anim = "move_m@alien", e = ""}},
                {label = "Uzbrojony", type = "attitude", data = {lib = "anim_group_move_ballistic", anim = "anim_group_move_ballistic", e = ""}},
                {label = "Arogancki", type = "attitude", data = {lib = "move_f@arrogant@a", anim = "move_f@arrogant@a", e = ""}},
                {label = "Swagger", type = "attitude", data = {lib = "move_m@swagger", anim = "move_m@swagger", e = ""}},
            }
        },
        {
            name = 'porn',
            label = 'Pegi 21',
            items = {
                {label = "Dokowanie", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@air_shagging", anim = "air_shagging", loop = 0, e = "dokowanie"}},
                {label = "Posuwanie", type = "anim", data = {lib = "timetable@trevor@skull_loving_bear", anim = "skull_loving_bear", loop = 1, e = "posuwanie"}},
                {label = "Gest walenia", type = "anim", data = {lib = "anim@mp_player_intupperdock", anim = "idle_a", loop = 57, e = "walenie"}},
                {label = "Walenie konia 1 [Pojazd]", type = "anim", data = {lib = "anim@mp_player_intincarwanklow@ps@", anim = "idle_a", loop = 1, e = "walenie2"}},
                {label = "Walenie konia 2 - na kogoś", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@wank", anim = "wank", loop = 0, e = "walenie3"}},   
                {label = "Eksponowanie wdzięków - przód", type = "anim", data = {lib = "mini@hookers_sp", anim = "ilde_b", loop = 1, e = "wdzieki"}},
                {label = "Eksponowanie wdzięków - tył", type = "anim", data = {lib = "mini@hookers_sp", anim = "ilde_c", loop = 1, e = "wdzieki2"}},
                {label = "Taniec erotyczny 1", type = "anim", data = {lib = "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", anim = "ld_girl_a_song_a_p1_f", loop = 1, e = "erotyczny"}},
                {label = "Taniec erotyczny 2", type = "anim", data = {lib = "mini@strip_club@private_dance@part2", anim = "priv_dance_p2", loop = 1, e = "erotyczny2"}},
                {label = "Taniec erotyczny 3", type = "anim", data = {lib = "mini@strip_club@private_dance@part3", anim = "priv_dance_p3", loop = 1, e = "erotyczny3"}},
            }
        },
        {
            name = 'custom',
            label = 'Customowe',
            items = {
                {label = "Billy Bounce", type = "anim", data = {lib = "custom@billybounce", anim = "billybounce", loop = 1, e = "billybounce"}},
                {label = "Downward", type = "anim", data = {lib = "custom@downward_fortnite", anim = "downward_fortnite", loop = 1, e = "downward"}},
                {label = "Pullup", type = "anim", data = {lib = "custom@pullup", anim = "pullup", loop = 1, e = "pullup"}},
                {label = "Rollie", type = "anim", data = {lib = "custom@rollie", anim = "rollie", loop = 1, e = "rollie"}},
                {label = "Wanna see me", type = "anim", data = {lib = "custom@wanna_see_me", anim = "wanna_see_me", loop = 1, e = "wannaseeme"}},
                {label = "Arm Swirl", type = "anim", data = {lib = "custom@armswirl", anim = "armswirl", loop = 1, e = "armswirl"}},
                {label = "Arm Wave", type = "anim", data = {lib = "custom@armwave", anim = "armwave", loop = 1, e = "armwave"}},
                {label = "Circle Crunch", type = "anim", data = {lib = "custom@circle_crunch", anim = "circle_crunch", loop = 1, e = "circlecrunch"}},
                {label = "Dig", type = "anim", data = {lib = "custom@dig", anim = "dig", loop = 1, e = "dig"}},
                {label = "Gangnam Style", type = "anim", data = {lib = "custom@gangnamstyle", anim = "gangnamstyle", loop = 1, e = "gangnamstyle"}},
                {label = "Makarena", type = "anim", data = {lib = "custom@makarena", anim = "makarena", loop = 1, e = "makarena"}},
                {label = "Maraschino", type = "anim", data = {lib = "custom@maraschino", anim = "maraschino", loop = 1, e = "maraschino"}},
                {label = "Pick From Ground", type = "anim", data = {lib = "custom@pickfromground", anim = "pickfromground", loop = 1, e = "pickfromground"}},
                {label = "Salsa", type = "anim", data = {lib = "custom@salsa", anim = "salsa", loop = 1, e = "salsa"}},
                {label = "What", type = "anim", data = {lib = "custom@what_idk", anim = "what_idk", loop = 1, e = "whatidk"}},
                {label = "Kaczuszki", type = "anim", data = {lib = "divined@dancesv2@new", anim = "divdance6", loop = 1, e = "kaczuszki"}},
                {label = "Breakdance 1", type = "anim", data = {lib = "divined@dances@new", anim = "ddance1", loop = 1, e = "ddance1"}},
                {label = "Breakdance 2", type = "anim", data = {lib = "divined@dances@new", anim = "ddance2", loop = 1, e = "ddance2"}},
                {label = "Breakdance 3", type = "anim", data = {lib = "divined@dances@new", anim = "ddance3", loop = 1, e = "ddance3"}},
                {label = "Breakdance 4", type = "anim", data = {lib = "divined@dances@new", anim = "ddance4", loop = 1, e = "ddance4"}},
                {label = "Breakdance 5", type = "anim", data = {lib = "divined@dances@new", anim = "ddance5", loop = 1, e = "ddance5"}},
                {label = "Breakdance 6", type = "anim", data = {lib = "divined@dances@new", anim = "ddance6", loop = 1, e = "ddance6"}},
                {label = "Breakdance 7", type = "anim", data = {lib = "divined@dances@new", anim = "ddance7", loop = 1, e = "ddance7"}},
                {label = "Breakdance 8", type = "anim", data = {lib = "divined@dances@new", anim = "ddance8", loop = 1, e = "ddance8"}},
                {label = "Breakdance 9", type = "anim", data = {lib = "divined@dances@new", anim = "ddance9", loop = 1, e = "ddance9"}},
                {label = "Breakdance 10", type = "anim", data = {lib = "divined@dances@new", anim = "ddance10", loop = 1, e = "ddance10"}},
                {label = "Breakdance 11", type = "anim", data = {lib = "divined@dances@new", anim = "ddance11", loop = 1, e = "ddance11"}},
                {label = "Breakdance 12", type = "anim", data = {lib = "divined@dances@new", anim = "ddance12", loop = 1, e = "ddance12"}},
                {label = "Breakdance 13", type = "anim", data = {lib = "divined@dances@new", anim = "ddance13", loop = 1, e = "ddance13"}},
                {label = "Breakdance 14", type = "anim", data = {lib = "divined@dancesv2@new", anim = "divdance1", loop = 1, e = "ddance14"}},
                {label = "Breakdance 15", type = "anim", data = {lib = "divined@dancesv2@new", anim = "divdance2", loop = 1, e = "ddance15"}},
                {label = "Breakdance 16", type = "anim", data = {lib = "divined@dancesv2@new", anim = "divdance3", loop = 1, e = "ddance16"}},
                {label = "Breakdance 17", type = "anim", data = {lib = "divined@dancesv2@new", anim = "divdance4", loop = 1, e = "ddance17"}},
                {label = "Breakdance 18", type = "anim", data = {lib = "divined@dancesv2@new", anim = "divdance5", loop = 1, e = "ddance18"}},
                {label = "Breakdance 19", type = "anim", data = {lib = "divined@dancesv2@new", anim = "divdance7", loop = 1, e = "ddance19"}},
                {label = "Breakdance 20", type = "anim", data = {lib = "divined@dancesv2@new", anim = "divdance8", loop = 1, e = "ddance20"}},
                {label = "Breakdance 21", type = "anim", data = {lib = "divined@dancesv2@new", anim = "divdance10", loop = 1, e = "ddance21"}},
                {label = "Breakdance 22", type = "anim", data = {lib = "divined@dancesv2@new", anim = "divdance11", loop = 1, e = "ddance22"}},
                {label = "Breakdance 23", type = "anim", data = {lib = "divined@dancesv2@new", anim = "divdance12", loop = 1, e = "ddance23"}},
                {label = "Breakdance 24", type = "anim", data = {lib = "divined@dancesv2@new", anim = "divdance13", loop = 1, e = "ddance24"}},
                {label = "Breakdance 25", type = "anim", data = {lib = "divined@dancesv2@new", anim = "divdance14", loop = 1, e = "ddance25"}},
                {label = "Taniec FN1", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance1", loop = 1, e = "fn1"}},
                {label = "Taniec FN2", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance2", loop = 1, e = "fn2"}},
                {label = "Taniec FN3", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance3", loop = 1, e = "fn3"}},
                {label = "Taniec FN4", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance4", loop = 1, e = "fn4"}},
                {label = "Taniec FN5", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance5", loop = 1, e = "fn5"}},
                {label = "Taniec FN6", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance6", loop = 1, e = "fn6"}},
                {label = "Taniec FN7", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance7", loop = 1, e = "fn7"}},
                {label = "Taniec FN8", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance8", loop = 1, e = "fn8"}},
                {label = "Taniec FN9", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance9", loop = 1, e = "fn9"}},
                {label = "Taniec FN10", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance10", loop = 1, e = "fn10"}},
                {label = "Taniec FN11", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance11", loop = 1, e = "fn11"}},
                {label = "Taniec FN12", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance12", loop = 1, e = "fn12"}},
                {label = "Taniec FN13", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance13", loop = 1, e = "fn13"}},
                {label = "Taniec FN14", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance14", loop = 1, e = "fn14"}},
                {label = "Taniec FN15", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance15", loop = 1, e = "fn15"}},
                {label = "Taniec FN16", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance16", loop = 1, e = "fn16"}},
                {label = "Taniec FN17", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance17", loop = 1, e = "fn17"}},
                {label = "Taniec FN18", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance18", loop = 1, e = "fn18"}},
                {label = "Taniec FN19", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance19", loop = 1, e = "fn19"}},
                {label = "Taniec FN20", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance20", loop = 1, e = "fn20"}},
            }
        },
        {
            name = 'drill',
            label = 'Sturdy',
            items = {
                {label = "Sturdy 1", type = "anim", data = {lib = "divined@drillb2@new", anim = "sturdy", loop = 1, e = "sturdy1"}},
                {label = "Sturdy 2", type = "anim", data = {lib = "div@woowalk@test", anim = "sturdy2", loop = 1, e = "sturdy2"}},
                {label = "Sturdy 3", type = "anim", data = {lib = "divined@drillb2@new", anim = "sturdyground", loop = 1, e = "sturdy3"}},
                {label = "Sturdy 4", type = "anim", data = {lib = "nito_sturdy18@animation", anim = "nito_sturdy18_clip", loop = 1, e = "sturdy4"}},
                {label = "Sturdy 5", type = "anim", data = {lib = "div@woowalk@test", anim = "woowalk", loop = 1, e = "sturdy5"}},
                {label = "Sturdy 6", type = "anim", data = {lib = "div@woowalk@test", anim = "blixkytwirl2", loop = 1, e = "sturdy6"}},
                {label = "Sturdy 7", type = "anim", data = {lib = "divined@drpackv3@new", anim = "kaisturdy", loop = 1, e = "sturdy7"}},
                {label = "Sturdy 8", type = "anim", data = {lib = "adxttisturdy@animation", anim = "adxttisturdy_clip", loop = 1, e = "sturdy8"}},
                {label = "Sturdy 9", type = "anim", data = {lib = "adxttisturdy2@animation", anim = "adxttisturdy2_clip", loop = 1, e = "sturdy9"}},
                {label = "Sturdy 10", type = "anim", data = {lib = "adxttisturdy3@animation", anim = "adxttisturdy3_clip", loop = 1, e = "sturdy10"}},
                {label = "Sturdy 11", type = "anim", data = {lib = "adxttisturdy4@animation", anim = "adxttisturdy4_clip", loop = 1, e = "sturdy11"}},
                {label = "Sturdy 12", type = "anim", data = {lib = "adxttisturdy5@animation", anim = "adxttisturdy5_clip", loop = 1, e = "sturdy12"}},
                {label = "Sturdy 13", type = "anim", data = {lib = "adxttisturdy6@animation", anim = "adxttisturdy6_clip", loop = 1, e = "sturdy13"}},
                {label = "Sturdy 14", type = "anim", data = {lib = "nito_sturdy_dance1@animation", anim = "nito_sturdy_dance1_clip", loop = 1, e = "sturdy14"}},
                {label = "Sturdy 15", type = "anim", data = {lib = "nito_sturdy20@animation", anim = "nito_sturdy20_clip", loop = 1, e = "sturdy15"}},
                {label = "Sturdy 16", type = "anim", data = {lib = "nito_sturdy5@animation", anim = "nito_sturdy5_clip", loop = 1, e = "sturdy16"}},
                {label = "Sturdy 17", type = "anim", data = {lib = "nito_sturdy2_freethehometeam@animation", anim = "nito_sturdy2_freethehometeam_clip", loop = 1, e = "sturdy17"}},
                {label = "Sturdy 18", type = "anim", data = {lib = "nito_sturdy7@animation", anim = "nito_sturdy7_clip", loop = 1, e = "sturdy18"}},
                {label = "Sturdy 19", type = "anim", data = {lib = "nito_sturdy8@animation", anim = "nito_sturdy8_clip", loop = 1, e = "sturdy19"}},
                {label = "Sturdy 20", type = "anim", data = {lib = "nito_sturdy11@animation", anim = "nito_sturdy11_clip", loop = 1, e = "sturdy20"}},
                {label = "Sturdy 21", type = "anim", data = {lib = "nito_sturdy3_freethehometeam@animation", anim = "nito_sturdy3_freethehometeam_clip", loop = 1, e = "sturdy21"}},
                {label = "Sturdy 22", type = "anim", data = {lib = "nito_sturdy_mightyz@animation", anim = "nito_sturdy_mightyz_clip", loop = 1, e = "sturdy22"}},
                {label = "Sturdy 23", type = "anim", data = {lib = "nito_sturdy1@animation", anim = "nito_sturdy1_clip", loop = 1, e = "sturdy23"}},
                {label = "Sturdy 24", type = "anim", data = {lib = "divined@drpack@new", anim = "cripwalk3", loop = 1, e = "sturdy24"}},
                {label = "Sturdy 25", type = "anim", data = {lib = "divined@drpack@new", anim = "bloodwalk", loop = 1, e = "sturdy25"}},
                {label = "Sturdy 26", type = "anim", data = {lib = "divined@drpack@new", anim = "woowalkinx", loop = 1, e = "sturdy26"}},
                {label = "Sturdy 27", type = "anim", data = {lib = "divined@drillb2@new", anim = "walknstep", loop = 1, e = "sturdy27"}},
            }
        },
        {
            name = 'gsign',
            label = 'Gang Sign',
            items = {
                {label = "Regular Stance 1", type = "anim", data = {lib = "qpacc@regularstance1", anim = "regularstance1_clip", loop = 1, e = "gsign038"}},
                {label = "Regular Stance 2", type = "anim", data = {lib = "qpacc@regularstance2", anim = "regularstance2_clip", loop = 1, e = "gsign039"}},
                {label = "Regular Stance 3", type = "anim", data = {lib = "qpacc@regularstance3", anim = "regularstance3_clip", loop = 1, e = "gsign040"}},
                {label = "Regular Stance 4", type = "anim", data = {lib = "qpacc@regularstance4", anim = "regularstance4_clip", loop = 1, e = "gsign041"}},
                {label = "Regular Stance 5", type = "anim", data = {lib = "qpacc@regularstance5", anim = "regularstance5_clip", loop = 1, e = "gsign042"}},
                {label = "Regular Stance 6", type = "anim", data = {lib = "qpacc@regularstance6", anim = "regularstance6_clip", loop = 1, e = "gsign043"}},
                {label = "Regular Stance 7", type = "anim", data = {lib = "qpacc@regularstance7", anim = "regularstance7_clip", loop = 1, e = "gsign044"}},
                {label = "Regular Stance 8", type = "anim", data = {lib = "qpacc@regularstance8", anim = "regularstance8_clip", loop = 1, e = "gsign045"}},
                {label = "Regular Stance 9", type = "anim", data = {lib = "qpacc@regularstance9", anim = "regularstance9_clip", loop = 1, e = "gsign046"}},
                {label = "Regular Stance 10", type = "anim", data = {lib = "qpacc@regularstance10", anim = "regularstance10_clip", loop = 1, e = "gsign047"}},
                {label = "Regular Stance 11", type = "anim", data = {lib = "qpacc@regularstance11", anim = "regularstance11_clip", loop = 1, e = "gsign048"}},
                {label = "Regular Stance 12", type = "anim", data = {lib = "qpacc@regularstance12", anim = "regularstance12_clip", loop = 1, e = "gsign049"}},
                {label = "Regular Stance 13", type = "anim", data = {lib = "qpacc@regularstance13", anim = "regularstance13_clip", loop = 1, e = "gsign050"}},
                {label = "Regular Stance 14", type = "anim", data = {lib = "qpacc@regularstance14", anim = "regularstance14_clip", loop = 1, e = "gsign051"}},
                {label = "Regular Stance 15", type = "anim", data = {lib = "qpacc@regularstance15", anim = "regularstance15_clip", loop = 1, e = "gsign052"}},
                {label = "Regular Stance 16", type = "anim", data = {lib = "qpacc@regularstance16", anim = "regularstance16_clip", loop = 1, e = "gsign053"}},
                {label = "Regular Stance 17", type = "anim", data = {lib = "qpacc@regularstance17", anim = "regularstance17_clip", loop = 1, e = "gsign054"}},
                {label = "Regular Stance 18", type = "anim", data = {lib = "qpacc@regularstance18", anim = "regularstance18_clip", loop = 1, e = "gsign055"}},
                {label = "Regular Stance 19", type = "anim", data = {lib = "qpacc@regularstance19", anim = "regularstance19_clip", loop = 1, e = "gsign056"}},
                {label = "Regular Stance 20", type = "anim", data = {lib = "qpacc@regularstance20", anim = "regularstance20_clip", loop = 1, e = "gsign057"}},
                {label = "Regular Stance 21", type = "anim", data = {lib = "qpacc@regularstance21", anim = "regularstance21_clip", loop = 1, e = "gsign058"}},
                {label = "Regular Stance 22", type = "anim", data = {lib = "qpacc@regularstance22", anim = "regularstance22_clip", loop = 1, e = "gsign059"}},
                {label = "Regular Stance 23", type = "anim", data = {lib = "qpacc@regularstance23", anim = "regularstance23_clip", loop = 1, e = "gsign060"}},
                {label = "Regular Stance 24", type = "anim", data = {lib = "qpacc@regularstance24", anim = "regularstance24_clip", loop = 1, e = "gsign061"}},
                {label = "Regular Stance 25", type = "anim", data = {lib = "qpacc@regularstance25", anim = "regularstance25_clip", loop = 1, e = "gsign062"}},
                {label = "Regular Stance 26", type = "anim", data = {lib = "qpacc@regularstance26", anim = "regularstance26_clip", loop = 1, e = "gsign063"}},
                {label = "Regular Stance 27", type = "anim", data = {lib = "qpacc@regularstance27", anim = "regularstance27_clip", loop = 1, e = "gsign064"}},
                {label = "Regular Stance 28", type = "anim", data = {lib = "qpacc@regularstance28", anim = "regularstance28_clip", loop = 1, e = "gsign065"}},
                {label = "Regular Stance 29", type = "anim", data = {lib = "qpacc@regularstance29", anim = "regularstance29_clip", loop = 1, e = "gsign066"}},
                {label = "Regular Stance 30", type = "anim", data = {lib = "qpacc@regularstance30", anim = "regularstance30_clip", loop = 1, e = "gsign067"}},
                {label = "Regular Stance 31", type = "anim", data = {lib = "qpacc@regularstance31", anim = "regularstance31_clip", loop = 1, e = "gsign068"}},
                {label = "Regular Stance 32", type = "anim", data = {lib = "qpacc@regularstance32", anim = "regularstance32_clip", loop = 1, e = "gsign069"}},
                {label = "Regular Stance 33", type = "anim", data = {lib = "qpacc@regularstance33", anim = "regularstance33_clip", loop = 1, e = "gsign070"}},
                {label = "Regular Stance 34", type = "anim", data = {lib = "qpacc@regularstance34", anim = "regularstance34_clip", loop = 1, e = "gsign071"}},
                {label = "Regular Stance 35", type = "anim", data = {lib = "qpacc@regularstance35", anim = "regularstance35_clip", loop = 1, e = "gsign072"}},
                {label = "Regular Stance 36", type = "anim", data = {lib = "qpacc@regularstance36", anim = "regularstance36_clip", loop = 1, e = "gsign073"}},
                {label = "Regular Stance 37", type = "anim", data = {lib = "qpacc@regularstance37", anim = "regularstance37_clip", loop = 1, e = "gsign074"}},
                {label = "Regular Stance 38", type = "anim", data = {lib = "qpacc@regularstance38", anim = "regularstance38_clip", loop = 1, e = "gsign075"}},
                {label = "Regular Stance 39", type = "anim", data = {lib = "qpacc@regularstance39", anim = "regularstance39_clip", loop = 1, e = "gsign076"}},
                {label = "Regular Stance 40", type = "anim", data = {lib = "qpacc@regularstance40", anim = "regularstance40_clip", loop = 1, e = "gsign077"}},
                {label = "Pose 11", type = "anim", data = {lib = "pose11@94glocky", anim = "pose11_clip", loop = 1, e = "gsign004"}},
                {label = "NY Gang 1", type = "anim", data = {lib = "qpacc@nygang1", anim = "nygang1_clip", loop = 1, e = "gsign005"}},
                {label = "NY Gang 2", type = "anim", data = {lib = "qpacc@nygang2", anim = "nygang2_clip", loop = 1, e = "gsign006"}},
                {label = "NY Gang 3", type = "anim", data = {lib = "qpacc@nygang3", anim = "nygang3_clip", loop = 1, e = "gsign007"}},
                {label = "NY Gang 4", type = "anim", data = {lib = "qpacc@nygang4", anim = "nygang4_clip", loop = 1, e = "gsign008"}},
                {label = "NY Gang 5", type = "anim", data = {lib = "qpacc@nygang5", anim = "nygang5_clip", loop = 1, e = "gsign009"}},
                {label = "NY Gang 6", type = "anim", data = {lib = "qpacc@nygang6", anim = "nygang6_clip", loop = 1, e = "gsign010"}},
                {label = "NY Gang 7", type = "anim", data = {lib = "qpacc@nygang7", anim = "nygang7_clip", loop = 1, e = "gsign011"}},
                {label = "NY Gang 8", type = "anim", data = {lib = "qpacc@nygang8", anim = "nygang8_clip", loop = 1, e = "gsign012"}},
                {label = "NY Gang 9", type = "anim", data = {lib = "qpacc@nygang9", anim = "nygang9_clip", loop = 1, e = "gsign013"}},
                {label = "NY Gang 10", type = "anim", data = {lib = "qpacc@nygang10", anim = "nygang10_clip", loop = 1, e = "gsign014"}},
                {label = "NY Gang 11", type = "anim", data = {lib = "qpacc@nygang11", anim = "nygang11_clip", loop = 1, e = "gsign015"}},
                {label = "NY Gang 12", type = "anim", data = {lib = "qpacc@nygang12", anim = "nygang12_clip", loop = 1, e = "gsign016"}},
                {label = "NY Gang 13", type = "anim", data = {lib = "qpacc@nygang13", anim = "nygang13_clip", loop = 1, e = "gsign017"}},
                {label = "NY Gang 14", type = "anim", data = {lib = "qpacc@nygang14", anim = "nygang14_clip", loop = 1, e = "gsign018"}},
                {label = "NY Gang 15", type = "anim", data = {lib = "qpacc@nygang15", anim = "nygang15_clip", loop = 1, e = "gsign019"}},
                {label = "NY Gang 16", type = "anim", data = {lib = "qpacc@nygang16", anim = "nygang16_clip", loop = 1, e = "gsign020"}},
                {label = "NY Gang 17", type = "anim", data = {lib = "qpacc@nygang17", anim = "nygang17_clip", loop = 1, e = "gsign021"}},
                {label = "NY Gang 18", type = "anim", data = {lib = "qpacc@nygang18", anim = "nygang18_clip", loop = 1, e = "gsign022"}},
                {label = "NY Gang 19", type = "anim", data = {lib = "qpacc@nygang19", anim = "nygang19_clip", loop = 1, e = "gsign023"}},
                {label = "NY Gang 20", type = "anim", data = {lib = "qpacc@nygang20", anim = "nygang20_clip", loop = 1, e = "gsign024"}},
                {label = "NY Gang 21", type = "anim", data = {lib = "qpacc@nygang21", anim = "nygang21_clip", loop = 1, e = "gsign025"}},
                {label = "NY Gang 22", type = "anim", data = {lib = "qpacc@nygang22", anim = "nygang22_clip", loop = 1, e = "gsign026"}},
                {label = "NY Gang 23", type = "anim", data = {lib = "qpacc@nygang23", anim = "nygang23_clip", loop = 1, e = "gsign027"}},
                {label = "NY Gang 24", type = "anim", data = {lib = "qpacc@nygang24", anim = "nygang24_clip", loop = 1, e = "gsign028"}},
                {label = "NY Gang 25", type = "anim", data = {lib = "qpacc@nygang25", anim = "nygang25_clip", loop = 1, e = "gsign029"}},
                {label = "NY Gang 26", type = "anim", data = {lib = "qpacc@nygang26", anim = "nygang26_clip", loop = 1, e = "gsign030"}},
                {label = "NY Gang 27", type = "anim", data = {lib = "qpacc@nygang27", anim = "nygang27_clip", loop = 1, e = "gsign031"}},
                {label = "NY Gang 28", type = "anim", data = {lib = "qpacc@nygang28", anim = "nygang28_clip", loop = 1, e = "gsign032"}},
                {label = "NY Gang 29", type = "anim", data = {lib = "qpacc@nygang29", anim = "nygang29_clip", loop = 1, e = "gsign033"}},
                {label = "NY Gang 30", type = "anim", data = {lib = "qpacc@nygang30", anim = "nygang30_clip", loop = 1, e = "gsign034"}},
                {label = "NY Gang 31", type = "anim", data = {lib = "qpacc@nygang31", anim = "nygang31_clip", loop = 1, e = "gsign035"}},
                {label = "NY Gang 32", type = "anim", data = {lib = "qpacc@nygang32", anim = "nygang32_clip", loop = 1, e = "gsign036"}},
                {label = "NY Gang 33", type = "anim", data = {lib = "qpacc@nygang33", anim = "nygang33_clip", loop = 1, e = "gsign037"}},
                {label = "NY Gang 34", type = "anim", data = {lib = "qpacc@nygang34", anim = "nygang34_clip", loop = 1, e = "gsign038"}},
                {label = "NY Gang 35", type = "anim", data = {lib = "qpacc@nygang35", anim = "nygang35_clip", loop = 1, e = "gsign039"}},
                {label = "NY Gang 36", type = "anim", data = {lib = "qpacc@nygang36", anim = "nygang36_clip", loop = 1, e = "gsign040"}},
                {label = "NY Gang 37", type = "anim", data = {lib = "qpacc@nygang37", anim = "nygang37_clip", loop = 1, e = "gsign041"}},
                {label = "NY Gang 38", type = "anim", data = {lib = "qpacc@nygang38", anim = "nygang38_clip", loop = 1, e = "gsign042"}},
                {label = "NY Gang 39", type = "anim", data = {lib = "qpacc@nygang39", anim = "nygang39_clip", loop = 1, e = "gsign043"}},
                {label = "NY Gang 40", type = "anim", data = {lib = "qpacc@nygang40", anim = "nygang40_clip", loop = 1, e = "gsign044"}},
                {label = "Gang Sign 41 Movin Crips", type = "anim", data = {lib = "94glockymovin@animation", anim = "movin_clip", loop = 1, e = "gsign41"}},
                {label = "Gang Sign 42 CHOO/WOOK", type = "anim", data = {lib = "94glockychoowook@animation", anim = "choowook_clip", loop = 1, e = "gsign42"}},
                {label = "Gang Sign 43 Handspocket", type = "anim", data = {lib = "94glockypocket@animation", anim = "pocket_clip", loop = 1, e = "gsign43"}},
                {label = "Gang Sign 44 NLE Choppa", type = "anim", data = {lib = "94glockycrips3@animation", anim = "crips3_clip", loop = 1, e = "gsign44"}},
                {label = "Gang Sign 45 Slime Pose", type = "anim", data = {lib = "pose1@94glocky", anim = "94glockypose1_clip", loop = 1, e = "gsign45"}},
                {label = "Gang Sign 46 OGzK", type = "anim", data = {lib = "oyogzk@94glocky", anim = "94glockyoyogzk_clip", loop = 1, e = "gsign46"}},
                {label = "Gang Sign 47 Simple Pose", type = "anim", data = {lib = "pose2@94glocky", anim = "94glockypose2_clip", loop = 1, e = "gsign47"}},
                {label = "Gang Sign 48 DOA OYK", type = "anim", data = {lib = "94glockydoaogzk@animation", anim = "doaogzk_clip", loop = 1, e = "gsign48"}},
                {label = "Gang Sign 49 Pose KayKay", type = "anim", data = {lib = "pose3@94glocky", anim = "94glockypose3_clip", loop = 1, e = "gsign49"}},
                {label = "Gang Sign 50 Hound 1", type = "anim", data = {lib = "pose@drilly@94glocky", anim = "posedrilly1_clip", loop = 1, e = "gsign50"}}
            }
        }
    },

    Synced = {
        {
            ['Label'] = 'Przytul',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'kisses_guy_a', ['Flags'] = 0,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'kisses_guy_b', ['Flags'] = 0, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.05,
                    ['yP'] = 1.15,
                    ['zP'] = -0.05,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Piątka',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'highfive_guy_a', ['Flags'] = 0,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'highfive_guy_b', ['Flags'] = 0, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = -0.5,
                    ['yP'] = 1.25,
                    ['zP'] = 0.0,
    
                    ['xR'] = 0.9,
                    ['yR'] = 0.3,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Przytul po przyjacielsku',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'hugs_guy_a', ['Flags'] = 0,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'hugs_guy_b', ['Flags'] = 0, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = -0.025,
                    ['yP'] = 1.15,
                    ['zP'] = 0.0,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Żółwik',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationpaired@f_f_fist_bump', ['Anim'] = 'fist_bump_left', ['Flags'] = 0,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationpaired@f_f_fist_bump', ['Anim'] = 'fist_bump_right', ['Flags'] = 0, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = -0.6,
                    ['yP'] = 0.9,
                    ['zP'] = 0.0,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 270.0,
                }
            }
        },
        {
            ['Label'] = 'Podaj ręke (koleżeńskie)',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'handshake_guy_a', ['Flags'] = 0,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'handshake_guy_b', ['Flags'] = 0, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.0,
                    ['yP'] = 1.2,
                    ['zP'] = 0.0,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Podaj ręke (oficjalnie)',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'mp_common', ['Anim'] = 'givetake1_a', ['Flags'] = 0,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'mp_common', ['Anim'] = 'givetake1_b', ['Flags'] = 0, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.075,
                    ['yP'] = 1.0,
                    ['zP'] = 0.0,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Uderz',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'plyr_takedown_rear_lefthook', ['Flags'] = 0,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'victim_takedown_front_cross_r', ['Flags'] = 0, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.05,
                    ['yP'] = 1.15,
                    ['zP'] = -0.05,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Uderz z liścia',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'plyr_takedown_front_slap', ['Flags'] = 0,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'victim_takedown_front_backslap', ['Flags'] = 0, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.05,
                    ['yP'] = 1.15,
                    ['zP'] = -0.05,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Uderz z główki',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'plyr_takedown_front_headbutt', ['Flags'] = 0,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'victim_takedown_front_headbutt', ['Flags'] = 0, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.05,
                    ['yP'] = 1.15,
                    ['zP'] = -0.05,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Gra w baseballa',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@arena@celeb@flat@paired@no_props@', ['Anim'] = 'baseball_a_player_a', ['Flags'] = 0,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@arena@celeb@flat@paired@no_props@', ['Anim'] = 'baseball_a_player_b', ['Flags'] = 0, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = -0.5,
                    ['yP'] = 1.25,
                    ['zP'] = 0.0,
    
                    ['xR'] = 0.9,
                    ['yR'] = 0.3,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Wspólny taniec 1',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_a@', ['Anim'] = 'low_center', ['Flags'] = 1,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_a@', ['Anim'] = 'low_center', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.05,
                    ['yP'] = 1.15,
                    ['zP'] = -0.05,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Wspólny taniec 2',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity', ['Anim'] = 'hi_dance_facedj_09_v1_female^1', ['Flags'] = 1,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity', ['Anim'] = 'hi_dance_facedj_09_v1_female^1', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.05,
                    ['yP'] = 1.15,
                    ['zP'] = -0.05,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Wspólny taniec 3',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_b@', ['Anim'] = 'high_center', ['Flags'] = 1,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_b@', ['Anim'] = 'high_center', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.05,
                    ['yP'] = 1.15,
                    ['zP'] = -0.05,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Wspólny taniec 4',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity', ['Anim'] = 'hi_dance_facedj_09_v2_female^1', ['Flags'] = 1,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity', ['Anim'] = 'hi_dance_facedj_09_v2_female^1', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.05,
                    ['yP'] = 1.15,
                    ['zP'] = -0.05,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Wspólny taniec 5',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@solomun_entourage@', ['Anim'] = 'mi_dance_facedj_17_v1_female^1', ['Flags'] = 1,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@solomun_entourage@', ['Anim'] = 'mi_dance_facedj_17_v1_female^1', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.05,
                    ['yP'] = 1.15,
                    ['zP'] = -0.05,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Wspólny taniec 6',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@lazlow@hi_podium@', ['Anim'] = 'danceidle_mi_17_crotchgrab_laz', ['Flags'] = 1,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@lazlow@hi_podium@', ['Anim'] = 'danceidle_mi_17_crotchgrab_laz', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.05,
                    ['yP'] = 1.15,
                    ['zP'] = -0.05,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Wspólny taniec 7',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationmale@uncle_disco', ['Anim'] = 'uncle_disco', ['Flags'] = 1,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationmale@uncle_disco', ['Anim'] = 'uncle_disco', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.05,
                    ['yP'] = 1.15,
                    ['zP'] = -0.05,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
    
        {
            ['Label'] = 'Wspólny taniec 8',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@casino@mini@dance@dance_solo@female@var_b@', ['Anim'] = 'high_center', ['Flags'] = 1,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@casino@mini@dance@dance_solo@female@var_b@', ['Anim'] = 'high_center', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.05,
                    ['yP'] = 1.15,
                    ['zP'] = -0.05,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
    
        {
            ['Label'] = 'Pocałuj',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'hs3_ext-20', ['Anim'] = 'cs_lestercrest_3_dual-20', ['Flags'] = 1,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'hs3_ext-20', ['Anim'] = 'csb_georginacheng_dual-20', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 0,
                    ['xP'] = 0.0,
                    ['yP'] = 0.53,
                    ['zP'] = 0.0,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
    
        {
            ['Label'] = 'Obejmowanie',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'misscarsteal2chad_goodbye', ['Anim'] = 'chad_armsaround_chad', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = -0.07,
                    ['yP'] = 0.63,
                    ['zP'] = 0.00,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.53,
                    ['zR'] = 180.0,
                    }
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'misscarsteal2chad_goodbye', ['Anim'] = 'chad_armsaround_girl', ['Flags'] = 1
            },
        },
    
        {
            ['Label'] = 'Zrób loda (na stojąco)',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'pimpsex_hooker', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.0,
                    ['yP'] = 0.65,
                    ['zP'] = 0.0,
    
                    ['xR'] = 120.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'pimpsex_punter', ['Flags'] = 1,
            },
        },
        {
            ['Label'] = 'Sex (na stojąco)',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'shagloop_hooker', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.05,
                    ['yP'] = 0.4,
                    ['zP'] = 0.0,
    
                    ['xR'] = 120.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'shagloop_pimp', ['Flags'] = 1,
            },
        },
        {
            ['Label'] = 'Anal (na stojąco)', 
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'rcmpaparazzo_2', ['Anim'] = 'shag_loop_a', ['Flags'] = 1,
            }, 
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'rcmpaparazzo_2', ['Anim'] = 'shag_loop_poppy', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.015,
                    ['yP'] = 0.35,
                    ['zP'] = 0.0,
    
                    ['xR'] = 0.9,
                    ['yR'] = 0.3,
                    ['zR'] = 0.0,
                },
            },
        },
        {
            ['Label'] = "Uprawiaj sex (pojazd)", 
            ['Car'] = true,
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'oddjobs@assassinate@vice@sex', ['Anim'] = 'frontseat_carsex_loop_m', ['Flags'] = 1,
            }, 
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'oddjobs@assassinate@vice@sex', ['Anim'] = 'frontseat_carsex_loop_f', ['Flags'] = 1,
            },
        },
        {
            ['Label'] = "Uprawiaj sex 2 (pojazd)", 
            ['Car'] = true,
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'random@drunk_driver_2', ['Anim'] = 'cardrunksex_loop_f', ['Flags'] = 1,
            }, 
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'random@drunk_driver_2', ['Anim'] = 'cardrunksex_loop_m', ['Flags'] = 1,
            },
        },
        {
            ['Label'] = "Zrób loda (pojazd)", 
            ['Car'] = true,
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'oddjobs@towing', ['Anim'] = 'm_blow_job_loop', ['Flags'] = 1,
            }, 
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'oddjobs@towing', ['Anim'] = 'f_blow_job_loop', ['Flags'] = 1,
            },
        },
    }
}

Config['Synced'] = {
    {
        ['Label'] = 'Przytul',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'kisses_guy_a', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'kisses_guy_b', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Piątka',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'highfive_guy_a', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'highfive_guy_b', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = -0.5,
                ['yP'] = 1.25,
                ['zP'] = 0.0,

                ['xR'] = 0.9,
                ['yR'] = 0.3,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Przytul po przyjacielsku',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'hugs_guy_a', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'hugs_guy_b', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = -0.025,
                ['yP'] = 1.15,
                ['zP'] = 0.0,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Żółwik',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationpaired@f_f_fist_bump', ['Anim'] = 'fist_bump_left', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationpaired@f_f_fist_bump', ['Anim'] = 'fist_bump_right', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = -0.6,
                ['yP'] = 0.9,
                ['zP'] = 0.0,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 270.0,
            }
        }
    },
    {
        ['Label'] = 'Podaj ręke (koleżeńskie)',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'handshake_guy_a', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'handshake_guy_b', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.0,
                ['yP'] = 1.2,
                ['zP'] = 0.0,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Podaj ręke (oficjalnie)',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_common', ['Anim'] = 'givetake1_a', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_common', ['Anim'] = 'givetake1_b', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.075,
                ['yP'] = 1.0,
                ['zP'] = 0.0,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Uderz',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'plyr_takedown_rear_lefthook', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'victim_takedown_front_cross_r', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Uderz z liścia',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'plyr_takedown_front_slap', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'victim_takedown_front_backslap', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Uderz z główki',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'plyr_takedown_front_headbutt', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'victim_takedown_front_headbutt', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Gra w baseballa',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@arena@celeb@flat@paired@no_props@', ['Anim'] = 'baseball_a_player_a', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@arena@celeb@flat@paired@no_props@', ['Anim'] = 'baseball_a_player_b', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = -0.5,
                ['yP'] = 1.25,
                ['zP'] = 0.0,

                ['xR'] = 0.9,
                ['yR'] = 0.3,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Wspólny taniec 1',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_a@', ['Anim'] = 'low_center', ['Flags'] = 1,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_a@', ['Anim'] = 'low_center', ['Flags'] = 1, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Wspólny taniec 2',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity', ['Anim'] = 'hi_dance_facedj_09_v1_female^1', ['Flags'] = 1,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity', ['Anim'] = 'hi_dance_facedj_09_v1_female^1', ['Flags'] = 1, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Wspólny taniec 3',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_b@', ['Anim'] = 'high_center', ['Flags'] = 1,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_b@', ['Anim'] = 'high_center', ['Flags'] = 1, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Wspólny taniec 4',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity', ['Anim'] = 'hi_dance_facedj_09_v2_female^1', ['Flags'] = 1,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity', ['Anim'] = 'hi_dance_facedj_09_v2_female^1', ['Flags'] = 1, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Wspólny taniec 5',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@solomun_entourage@', ['Anim'] = 'mi_dance_facedj_17_v1_female^1', ['Flags'] = 1,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@solomun_entourage@', ['Anim'] = 'mi_dance_facedj_17_v1_female^1', ['Flags'] = 1, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Wspólny taniec 6',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@lazlow@hi_podium@', ['Anim'] = 'danceidle_mi_17_crotchgrab_laz', ['Flags'] = 1,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@lazlow@hi_podium@', ['Anim'] = 'danceidle_mi_17_crotchgrab_laz', ['Flags'] = 1, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Wspólny taniec 7',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationmale@uncle_disco', ['Anim'] = 'uncle_disco', ['Flags'] = 1,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationmale@uncle_disco', ['Anim'] = 'uncle_disco', ['Flags'] = 1, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },

    {
        ['Label'] = 'Wspólny taniec 8',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@casino@mini@dance@dance_solo@female@var_b@', ['Anim'] = 'high_center', ['Flags'] = 1,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@casino@mini@dance@dance_solo@female@var_b@', ['Anim'] = 'high_center', ['Flags'] = 1, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },

    {
        ['Label'] = 'Pocałuj',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'hs3_ext-20', ['Anim'] = 'cs_lestercrest_3_dual-20', ['Flags'] = 1,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'hs3_ext-20', ['Anim'] = 'csb_georginacheng_dual-20', ['Flags'] = 1, ['Attach'] = {
                ['Bone'] = 0,
                ['xP'] = 0.0,
                ['yP'] = 0.53,
                ['zP'] = 0.0,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },

    {
        ['Label'] = 'Obejmowanie',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'misscarsteal2chad_goodbye', ['Anim'] = 'chad_armsaround_chad', ['Flags'] = 1, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = -0.07,
                ['yP'] = 0.63,
                ['zP'] = 0.00,

                ['xR'] = 0.0,
                ['yR'] = 0.53,
                ['zR'] = 180.0,
                }
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'misscarsteal2chad_goodbye', ['Anim'] = 'chad_armsaround_girl', ['Flags'] = 1
        },
    },

    {
        ['Label'] = 'Zrób loda (na stojąco)',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'pimpsex_hooker', ['Flags'] = 1, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.0,
                ['yP'] = 0.65,
                ['zP'] = 0.0,

                ['xR'] = 120.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'pimpsex_punter', ['Flags'] = 1,
        },
    },
    {
        ['Label'] = 'Sex (na stojąco)',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'shagloop_hooker', ['Flags'] = 1, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 0.4,
                ['zP'] = 0.0,

                ['xR'] = 120.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'shagloop_pimp', ['Flags'] = 1,
        },
    },
    {
        ['Label'] = 'Anal (na stojąco)', 
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'rcmpaparazzo_2', ['Anim'] = 'shag_loop_a', ['Flags'] = 1,
        }, 
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'rcmpaparazzo_2', ['Anim'] = 'shag_loop_poppy', ['Flags'] = 1, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.015,
                ['yP'] = 0.35,
                ['zP'] = 0.0,

                ['xR'] = 0.9,
                ['yR'] = 0.3,
                ['zR'] = 0.0,
            },
        },
    },
    {
        ['Label'] = "Uprawiaj sex (pojazd)", 
        ['Car'] = true,
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'oddjobs@assassinate@vice@sex', ['Anim'] = 'frontseat_carsex_loop_m', ['Flags'] = 1,
        }, 
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'oddjobs@assassinate@vice@sex', ['Anim'] = 'frontseat_carsex_loop_f', ['Flags'] = 1,
        },
    },
    {
        ['Label'] = "Uprawiaj sex 2 (pojazd)", 
        ['Car'] = true,
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'random@drunk_driver_2', ['Anim'] = 'cardrunksex_loop_f', ['Flags'] = 1,
        }, 
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'random@drunk_driver_2', ['Anim'] = 'cardrunksex_loop_m', ['Flags'] = 1,
        },
    },
    {
        ['Label'] = "Zrób loda (pojazd)", 
        ['Car'] = true,
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'oddjobs@towing', ['Anim'] = 'm_blow_job_loop', ['Flags'] = 1,
        }, 
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'oddjobs@towing', ['Anim'] = 'f_blow_job_loop', ['Flags'] = 1,
        },
    },
}