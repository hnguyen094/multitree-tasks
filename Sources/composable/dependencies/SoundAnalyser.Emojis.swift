//
//  SoundAnalyser.Emojis.swift
//  keepers-tech-demo
//
//  Created by hung on 1/21/24.
//

import Foundation

extension SoundAnalyser {
    public static let soundTypeEmojiMapping: [SoundType: String] = [
        .accordion: "🪗",
        .acoustic_guitar: "🎸",
//        .air_conditioner: "",
//        .air_horn: "",
            .aircraft: "🛩️",
        .airplane: "✈️",
        .alarm_clock: "⏰",
        .ambulance_siren: "🚑",
        .applause: "👏👏👏",
        .artillery_fire: "💣",
        .babble: "🗣️🗣️",
        .baby_crying: "👶😭",
        .baby_laughter: "👶😆",
//        .bagpipes: "",
        .banjo: "🪕",
        .basketball_bounce: "🏀",
        .bass_drum: "🥁",
        .bass_guitar: "🎸",
//        .bassoon: "",
        .bathtub_filling_washing: "🛁",
        .battle_cry: "🗣️✊",
        .bee_buzz: "🐝",
        .beep: "📟",
        .bell: "🔔",
        .belly_laugh: "🤣",
        .bicycle: "🚲",
        .bicycle_bell: "🛎️",
        .bird: "🦜",
        .bird_chirp_tweet: "🐦",
        .bird_flapping: "🕊️",
        .bird_squawk: "🐦‍⬛",
//        .bird_vocalization: "🪿",
        .biting: "🫦",
//        .blender: "",
        .boat_water_vehicle: "🛥️",
        .boiling: "🔥",
        .booing: "👎",
        .boom: "💥",
        .bowed_string_instrument: "🎻",
        .bowling_impact: "🎳",
        .brass_instrument: "🎺",
        .breathing: "🧘",
//        .burp: "🫧",
        .bus: "🚌",
        .camera: "📷",
        .car_horn: "🚕🎺",
        .car_passing_by: "🏎️",
        .cat: "🐈",
        .cat_meow: "🐱",
        .cat_purr: "😸",
//        .cello: "🎻",
        .chainsaw: "⛓️🪚",
        .chatter: "👥",
        .cheering: "🍻",
        .chewing: "👄",
        .chicken: "🐓",
        .chicken_cluck: "🐔",
        .children_shouting: "🚸",
        .chime: "🎐",
        .choir_singing: "🎤👥",
        .chopping_food: "🔪🥕",
        .chopping_wood: "🪓🪵",
        .chuckle_chortle: "🤭",
        .church_bell: "⛪️🔔",
        .civil_defense_siren: "🚨",
        .clapping: "👏",
//        .clarinet: ""
        .click: "🔘",
        .clock: "🕰️",
        .coin_dropping: "🪙",
        .cough: "😷",
        .cow_moo: "🐮",
//        .cowbell: "",
//        .coyote_howl: "",
        .cricket_chirp: "🦗",
        .crow_caw: "🐦‍⬛",
        .crowd: "👥👥👥",
//        .crumpling_crinkling: "",
//        .crushing: "",
        .crying_sobbing: "😭",
        .cutlery_silverware: "🍽️",
//        .cymbal: "",
//        .didgeridoo: "",
        .disc_scratching: "💽",
        .dishes_pots_pans: "🥘🍳",
        .dog: "🐕",
        .dog_bark: "🐶",
//        .dog_bow_wow: "",
//        .dog_growl: "",
//        .dog_whimper: "",
        .door: "🚪",
        .door_bell: "🚪🔔",
//        .door_slam: "",
//        .door_sliding: "",
//        .double_bass: "",
        .drawer_open_close: "🗃️",
//        .drill: "",
        .drum: "🥁",
        .duck_quack: "🦆",
        .electric_guitar: "🎸",
        .electric_piano: "🎹",
        .electric_shaver: "🪒",
//        .electronic_organ: "",
        .elk_bugle: "🫎",
        .emergency_vehicle: "🚑",
//        .engine: "",
//        .engine_accelerating_revving: "",
//        .engine_idling: "",
//        .engine_knocking: "",
//        .engine_starting: "",
        .eruption: "🌋",
        .finger_snapping: "🫰",
        .fire: "🔥",
//        .fire_crackle: "",
        .fire_engine_siren: "🚒",
        .firecracker: "🧨",
        .fireworks: "🎇",
        .flute: "🪈",
        .fly_buzz: "🪰",
//        .foghorn: "",
        .fowl: "🪿",
//        .french_horn: "",
        .frog: "🐸",
//        .frog_croak: "🐸",
        .frying_food: "🍳",
//        .gargling: "",
        .gasp: "😮",
        .giggling: "😂",
//        .glass_breaking: "🍸",
        .glass_clink: "🥂",
//        .glockenspiel: "",
//        .gong: "",
        .goose_honk: "🪿",
        .guitar: "🎸",
//        .guitar_strum: "",
//        .guitar_tapping: "",
        .gunshot_gunfire: "🔫",
//        .gurgling: "",
//        .hair_dryer: "",
        .hammer: "🔨",
        .hammond_organ: "🎹",
//        .harmonica: "",
//        .harp: "",
//        .harpsichord: "",
//        .hedge_trimmer: "",
        .helicopter: "🚁",
//        .hi_hat: "",
        .hiccup: "🫢",
        .horse_clip_clop: "🐎",
        .horse_neigh: "🐴",
        .humming: "😌🎵",
        .insect: "🐜",
//        .keyboard_musical: "",
        .keys_jangling: "🔑",
        .knock: "✊",
        .laughter: "😆",
//        .lawn_mower: "",
        .lion_roar: "🦁",
        .liquid_dripping: "💧",
        .liquid_filling_container: "🍶",
//        .liquid_pouring: "",
//        .liquid_sloshing: "",
//        .liquid_splashing: "",
//        .liquid_spraying: "",
//        .liquid_squishing: "",
        .liquid_trickle_dribble: "💧💧",
//        .mallet_percussion: "",
//        .mandolin: "",
//        .marimba_xylophone: "",
        .mechanical_fan: "⚙️🪭",
//        .microwave_oven: "",
        .mosquito_buzz: "🦟",
        .motorboat_speedboat: "🚤",
        .motorcycle: "🏍️",
        .music: "🎶",
        .nose_blowing: "👃🤧",
//        .oboe: "",
        .ocean: "🌊🐟🌊",
        .orchestra: "🎼",
//        .organ: "",
        .owl_hoot: "🦉",
        .percussion: "🪘",
        .person_running: "🏃‍♂️",
        .person_shuffling: "🚶‍♂️🔀",
        .person_walking: "🚶‍♂️",
        .piano: "🎹",
        .pig_oink: "🐷",
//        .pigeon_dove_coo: "",
        .playing_badminton: "🏸",
        .playing_hockey: "🏒",
//        .playing_squash: "",
        .playing_table_tennis: "🏓",
        .playing_tennis: "🎾",
        .playing_volleyball: "🏐",
//        .plucked_string_instrument: "",
        .police_siren: "🚔🚨",
//        .power_tool: "",
//        .power_windows: "",
        .printer: "🖨️",
        .race_car: "🏎️",
        .rail_transport: "🚊",
        .railroad_car: "🚋",
        .rain: "🌧️",
        .raindrop: "☔️💧",
        .rapping: "🎵🎤",
        .ratchet_and_pawl: "⚙️",
        .rattle_instrument: "🪇",
        .reverse_beeps: "🚙➡️",
        .ringtone: "📲",
        .rooster_crow: "🐔",
//        .rope_skipping: "",
        .rowboat_canoe_kayak: "🛶",
        .sailing: "⛵️",
        .saw: "🪚",
        .saxophone: "🎷",
        .scissors: "✂️",
        .screaming: "😱",
        .scuba_diving: "🤿",
        .sea_waves: "🌊",
        .sewing_machine: "🧵⚙️🪡",
        .sheep_bleat: "🐑",
//        .shofar: "",
        .shout: "😫",
        .sigh: "😮‍💨",
        .silence: "😶",
        .singing: "😄🎤",
        .singing_bowl: "🎵🥣",
        .sink_filling_washing: "🚰",
        .siren: "🚨",
//        .sitar: "",
        .skateboard: "🛹",
        .skiing: "⛷️",
        .slap_smack: "👋🤦",
        .slurp: "🍜",
        .smoke_detector: "💨🚭",
        .snake_hiss: "🐍",
        .snake_rattle: "🐍",
        .snare_drum: "🥁",
        .sneeze: "🤧",
        .snicker: "🤭",
        .snoring: "😴",
        .speech: "💬",
        .squeak: "🐭",
//        .steel_guitar_slide_guitar: "",
//        .steelpan: "",
//        .stream_burbling: "",
        .subway_metro: "🚇",
//        .synthesizer: "",
//        .tabla: "",
//        .tambourine: "",
//        .tap: "",
        .tearing: "📃",
        .telephone: "☎️",
        .telephone_bell_ringing: "☎️🛎️",
        .theremin: "",
        .thump_thud: "",
        .thunder: "⚡️",
        .thunderstorm: "⛈️",
        .tick: "⏱️",
        .tick_tock : "⏲️",
        .toilet_flush: "🚽",
        .toothbrush: "🪥",
        .traffic_noise: "🚥",
        .train: "🚂",
        .train_horn: "🚂📣",
        .train_wheels_squealing: "🚂🛞",
//        .train_whistle: "🚂",
//        .trombone: "",
        .truck: "🚛",
        .trumpet: "🎺",
//        .tuning_fork: "",
        .turkey_gobble: "🦃",
//        .typewriter: "⌨️",
        .typing: "🫳⌨️",
        .typing_computer_keyboard: "🫳⌨️",
//        .ukulele: "",
        .underwater_bubbling: "💦🫧",
//        .vacuum_cleaner: "",
//        .vehicle_skidding: "",
//        .vibraphone: "",
        .violin_fiddle: "🎻",
        .water: "💦",
//        .water_pump: "🚰",
        .water_tap_faucet: "🚰",
//        .waterfall: "",
        .whale_vocalization: "🐳",
        .whispering: "🤫",
        .whoosh_swoosh_swish: "🌬️💨",
        .wind: "💨🍃",
        .wind_chime: "🎐",
        .wind_instrument: "",
        .wind_noise_microphone: "",
        .wind_rustling_leaves: "💨🍂",
        .wood_cracking: "🪵🔥",
        .writing: "✍️",
        .yell: "😵",
        .yodeling: "🫸😮🎵",
//        .zipper: "",
//        .zither: ""
    ]
}
