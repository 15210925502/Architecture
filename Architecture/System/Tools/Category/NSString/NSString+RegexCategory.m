//
//  NSString+RegexCategory.m
//  testDemo
//
//  Created by 博爱 on 2016/11/7.
//  Copyright © 2016年 DS-Team. All rights reserved.
//

#import "NSString+RegexCategory.h"
#include <arpa/inet.h>
#include <ifaddrs.h>
#include <net/if.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreText/CoreText.h>

static NSDictionary * s_unicodeToCheatCodes = nil;
static NSDictionary * s_cheatCodesToUnicode = nil;

NSString *NilString(id string) {
    if ([string isKindOfClass:[NSNull class]] || [string isEqualToString:@"(null)"] || !string) {
        return @"";
    }else {
        return string;
    }
}

NSString *NullString(id string) {
    if ([string isKindOfClass:[NSNull class]] || !string) {
        return @"0";
    }else {
        return string;
    }
}

NSString *NilNumString(id string) {
    if (!string || [string isEqualToString:@"0"] || [string isKindOfClass:[NSNull class]]) {
        return @"0.00";
    }else {
        return string;
    }
}

@implementation NSString (RegexCategory)

+ (void)initializeEmojiCheatCodes{
    NSDictionary *forwardMap = @{
                                 @"😄": @":smile:",
                                 @"😆": @[@":laughing:", @":D"],
                                 @"😊": @":blush:",
                                 @"😃": @[@":smiley:", @":)", @":-)"],
                                 @"☺": @":relaxed:",
                                 @"😏": @":smirk:",
                                 @"😞": @[@":disappointed:", @":("],
                                 @"😍": @":heart_eyes:",
                                 @"😘": @":kissing_heart:",
                                 @"😚": @":kissing_closed_eyes:",
                                 @"😳": @":flushed:",
                                 @"😥": @":relieved:",
                                 @"😌": @":satisfied:",
                                 @"😁": @":grin:",
                                 @"😉": @[@":wink:", @";)", @";-)"],
                                 @"😜": @[@":wink2:", @":P"],
                                 @"😝": @":stuck_out_tongue_closed_eyes:",
                                 @"😀": @":grinning:",
                                 @"😗": @":kissing:",
                                 @"😙": @":kissing_smiling_eyes:",
                                 @"😛": @":stuck_out_tongue:",
                                 @"😴": @":sleeping:",
                                 @"😟": @":worried:",
                                 @"😦": @":frowning:",
                                 @"😧": @":anguished:",
                                 @"😮": @[@":open_mouth:", @":o"],
                                 @"😬": @":grimacing:",
                                 @"😕": @":confused:",
                                 @"😯": @":hushed:",
                                 @"😑": @":expressionless:",
                                 @"😒": @":unamused:",
                                 @"😅": @":sweat_smile:",
                                 @"😓": @":sweat:",
                                 @"😩": @":weary:",
                                 @"😔": @":pensive:",
                                 @"😞": @":dissapointed:",
                                 @"😖": @":confounded:",
                                 @"😨": @":fearful:",
                                 @"😰": @":cold_sweat:",
                                 @"😣": @":persevere:",
                                 @"😢": @":cry:",
                                 @"😭": @":sob:",
                                 @"😂": @":joy:",
                                 @"😲": @":astonished:",
                                 @"😱": @":scream:",
                                 @"😫": @":tired_face:",
                                 @"😠": @":angry:",
                                 @"😡": @":rage:",
                                 @"😤": @":triumph:",
                                 @"😪": @":sleepy:",
                                 @"😋": @":yum:",
                                 @"😷": @":mask:",
                                 @"😎": @":sunglasses:",
                                 @"😵": @":dizzy_face:",
                                 @"👿": @":imp:",
                                 @"😈": @":smiling_imp:",
                                 @"😐": @":neutral_face:",
                                 @"😶": @":no_mouth:",
                                 @"😇": @":innocent:",
                                 @"👽": @":alien:",
                                 @"💛": @":yellow_heart:",
                                 @"💙": @":blue_heart:",
                                 @"💜": @":purple_heart:",
                                 @"❤": @":heart:",
                                 @"💚": @":green_heart:",
                                 @"💔": @":broken_heart:",
                                 @"💓": @":heartbeat:",
                                 @"💗": @":heartpulse:",
                                 @"💕": @":two_hearts:",
                                 @"💞": @":revolving_hearts:",
                                 @"💘": @":cupid:",
                                 @"💖": @":sparkling_heart:",
                                 @"✨": @":sparkles:",
                                 @"⭐️": @":star:",
                                 @"🌟": @":star2:",
                                 @"💫": @":dizzy:",
                                 @"💥": @":boom:",
                                 @"💢": @":anger:",
                                 @"❗": @":exclamation:",
                                 @"❓": @":question:",
                                 @"❕": @":grey_exclamation:",
                                 @"❔": @":grey_question:",
                                 @"💤": @":zzz:",
                                 @"💨": @":dash:",
                                 @"💦": @":sweat_drops:",
                                 @"🎶": @":notes:",
                                 @"🎵": @":musical_note:",
                                 @"🔥": @":fire:",
                                 @"💩": @[@":poop:", @":hankey:", @":shit:"],
                                 @"👍": @[@":+1:", @":thumbsup:"],
                                 @"👎": @[@":-1:", @":thumbsdown:"],
                                 @"👌": @":ok_hand:",
                                 @"👊": @":punch:",
                                 @"✊": @":fist:",
                                 @"✌": @":v:",
                                 @"👋": @":wave:",
                                 @"✋": @":hand:",
                                 @"👐": @":open_hands:",
                                 @"☝": @":point_up:",
                                 @"👇": @":point_down:",
                                 @"👈": @":point_left:",
                                 @"👉": @":point_right:",
                                 @"🙌": @":raised_hands:",
                                 @"🙏": @":pray:",
                                 @"👆": @":point_up_2:",
                                 @"👏": @":clap:",
                                 @"💪": @":muscle:",
                                 @"🚶": @":walking:",
                                 @"🏃": @":runner:",
                                 @"👫": @":couple:",
                                 @"👪": @":family:",
                                 @"👬": @":two_men_holding_hands:",
                                 @"👭": @":two_women_holding_hands:",
                                 @"💃": @":dancer:",
                                 @"👯": @":dancers:",
                                 @"🙆": @":ok_woman:",
                                 @"🙅": @":no_good:",
                                 @"💁": @":information_desk_person:",
                                 @"🙋": @":raised_hand:",
                                 @"👰": @":bride_with_veil:",
                                 @"🙎": @":person_with_pouting_face:",
                                 @"🙍": @":person_frowning:",
                                 @"🙇": @":bow:",
                                 @"💏": @":couplekiss:",
                                 @"💑": @":couple_with_heart:",
                                 @"💆": @":massage:",
                                 @"💇": @":haircut:",
                                 @"💅": @":nail_care:",
                                 @"👦": @":boy:",
                                 @"👧": @":girl:",
                                 @"👩": @":woman:",
                                 @"👨": @":man:",
                                 @"👶": @":baby:",
                                 @"👵": @":older_woman:",
                                 @"👴": @":older_man:",
                                 @"👱": @":person_with_blond_hair:",
                                 @"👲": @":man_with_gua_pi_mao:",
                                 @"👳": @":man_with_turban:",
                                 @"👷": @":construction_worker:",
                                 @"👮": @":cop:",
                                 @"👼": @":angel:",
                                 @"👸": @":princess:",
                                 @"😺": @":smiley_cat:",
                                 @"😸": @":smile_cat:",
                                 @"😻": @":heart_eyes_cat:",
                                 @"😽": @":kissing_cat:",
                                 @"😼": @":smirk_cat:",
                                 @"🙀": @":scream_cat:",
                                 @"😿": @":crying_cat_face:",
                                 @"😹": @":joy_cat:",
                                 @"😾": @":pouting_cat:",
                                 @"👹": @":japanese_ogre:",
                                 @"👺": @":japanese_goblin:",
                                 @"🙈": @":see_no_evil:",
                                 @"🙉": @":hear_no_evil:",
                                 @"🙊": @":speak_no_evil:",
                                 @"💂": @":guardsman:",
                                 @"💀": @":skull:",
                                 @"👣": @":feet:",
                                 @"👄": @":lips:",
                                 @"💋": @":kiss:",
                                 @"💧": @":droplet:",
                                 @"👂": @":ear:",
                                 @"👀": @":eyes:",
                                 @"👃": @":nose:",
                                 @"👅": @":tongue:",
                                 @"💌": @":love_letter:",
                                 @"👤": @":bust_in_silhouette:",
                                 @"👥": @":busts_in_silhouette:",
                                 @"💬": @":speech_balloon:",
                                 @"💭": @":thought_balloon:",
                                 @"☀": @":sunny:",
                                 @"☔": @":umbrella:",
                                 @"☁": @":cloud:",
                                 @"❄": @":snowflake:",
                                 @"⛄": @":snowman:",
                                 @"⚡": @":zap:",
                                 @"🌀": @":cyclone:",
                                 @"🌁": @":foggy:",
                                 @"🌊": @":ocean:",
                                 @"🐱": @":cat:",
                                 @"🐶": @":dog:",
                                 @"🐭": @":mouse:",
                                 @"🐹": @":hamster:",
                                 @"🐰": @":rabbit:",
                                 @"🐺": @":wolf:",
                                 @"🐸": @":frog:",
                                 @"🐯": @":tiger:",
                                 @"🐨": @":koala:",
                                 @"🐻": @":bear:",
                                 @"🐷": @":pig:",
                                 @"🐽": @":pig_nose:",
                                 @"🐮": @":cow:",
                                 @"🐗": @":boar:",
                                 @"🐵": @":monkey_face:",
                                 @"🐒": @":monkey:",
                                 @"🐴": @":horse:",
                                 @"🐎": @":racehorse:",
                                 @"🐫": @":camel:",
                                 @"🐑": @":sheep:",
                                 @"🐘": @":elephant:",
                                 @"🐼": @":panda_face:",
                                 @"🐍": @":snake:",
                                 @"🐦": @":bird:",
                                 @"🐤": @":baby_chick:",
                                 @"🐥": @":hatched_chick:",
                                 @"🐣": @":hatching_chick:",
                                 @"🐔": @":chicken:",
                                 @"🐧": @":penguin:",
                                 @"🐢": @":turtle:",
                                 @"🐛": @":bug:",
                                 @"🐝": @":honeybee:",
                                 @"🐜": @":ant:",
                                 @"🐞": @":beetle:",
                                 @"🐌": @":snail:",
                                 @"🐙": @":octopus:",
                                 @"🐠": @":tropical_fish:",
                                 @"🐟": @":fish:",
                                 @"🐳": @":whale:",
                                 @"🐋": @":whale2:",
                                 @"🐬": @":dolphin:",
                                 @"🐄": @":cow2:",
                                 @"🐏": @":ram:",
                                 @"🐀": @":rat:",
                                 @"🐃": @":water_buffalo:",
                                 @"🐅": @":tiger2:",
                                 @"🐇": @":rabbit2:",
                                 @"🐉": @":dragon:",
                                 @"🐐": @":goat:",
                                 @"🐓": @":rooster:",
                                 @"🐕": @":dog2:",
                                 @"🐖": @":pig2:",
                                 @"🐁": @":mouse2:",
                                 @"🐂": @":ox:",
                                 @"🐲": @":dragon_face:",
                                 @"🐡": @":blowfish:",
                                 @"🐊": @":crocodile:",
                                 @"🐪": @":dromedary_camel:",
                                 @"🐆": @":leopard:",
                                 @"🐈": @":cat2:",
                                 @"🐩": @":poodle:",
                                 @"🐾": @":paw_prints:",
                                 @"💐": @":bouquet:",
                                 @"🌸": @":cherry_blossom:",
                                 @"🌷": @":tulip:",
                                 @"🍀": @":four_leaf_clover:",
                                 @"🌹": @":rose:",
                                 @"🌻": @":sunflower:",
                                 @"🌺": @":hibiscus:",
                                 @"🍁": @":maple_leaf:",
                                 @"🍃": @":leaves:",
                                 @"🍂": @":fallen_leaf:",
                                 @"🌿": @":herb:",
                                 @"🍄": @":mushroom:",
                                 @"🌵": @":cactus:",
                                 @"🌴": @":palm_tree:",
                                 @"🌲": @":evergreen_tree:",
                                 @"🌳": @":deciduous_tree:",
                                 @"🌰": @":chestnut:",
                                 @"🌱": @":seedling:",
                                 @"🌼": @":blossum:",
                                 @"🌾": @":ear_of_rice:",
                                 @"🐚": @":shell:",
                                 @"🌐": @":globe_with_meridians:",
                                 @"🌞": @":sun_with_face:",
                                 @"🌝": @":full_moon_with_face:",
                                 @"🌚": @":new_moon_with_face:",
                                 @"🌑": @":new_moon:",
                                 @"🌒": @":waxing_crescent_moon:",
                                 @"🌓": @":first_quarter_moon:",
                                 @"🌔": @":waxing_gibbous_moon:",
                                 @"🌕": @":full_moon:",
                                 @"🌖": @":waning_gibbous_moon:",
                                 @"🌗": @":last_quarter_moon:",
                                 @"🌘": @":waning_crescent_moon:",
                                 @"🌜": @":last_quarter_moon_with_face:",
                                 @"🌛": @":first_quarter_moon_with_face:",
                                 @"🌙": @":moon:",
                                 @"🌍": @":earth_africa:",
                                 @"🌎": @":earth_americas:",
                                 @"🌏": @":earth_asia:",
                                 @"🌋": @":volcano:",
                                 @"🌌": @":milky_way:",
                                 @"⛅": @":partly_sunny:",
                                 @"🎍": @":bamboo:",
                                 @"💝": @":gift_heart:",
                                 @"🎎": @":dolls:",
                                 @"🎒": @":school_satchel:",
                                 @"🎓": @":mortar_board:",
                                 @"🎏": @":flags:",
                                 @"🎆": @":fireworks:",
                                 @"🎇": @":sparkler:",
                                 @"🎐": @":wind_chime:",
                                 @"🎑": @":rice_scene:",
                                 @"🎃": @":jack_o_lantern:",
                                 @"👻": @":ghost:",
                                 @"🎅": @":santa:",
                                 @"🎱": @":8ball:",
                                 @"⏰": @":alarm_clock:",
                                 @"🍎": @":apple:",
                                 @"🎨": @":art:",
                                 @"🍼": @":baby_bottle:",
                                 @"🎈": @":balloon:",
                                 @"🍌": @":banana:",
                                 @"📊": @":bar_chart:",
                                 @"⚾": @":baseball:",
                                 @"🏀": @":basketball:",
                                 @"🛀": @":bath:",
                                 @"🛁": @":bathtub:",
                                 @"🔋": @":battery:",
                                 @"🍺": @":beer:",
                                 @"🍻": @":beers:",
                                 @"🔔": @":bell:",
                                 @"🍱": @":bento:",
                                 @"🚴": @":bicyclist:",
                                 @"👙": @":bikini:",
                                 @"🎂": @":birthday:",
                                 @"🃏": @":black_joker:",
                                 @"✒": @":black_nib:",
                                 @"📘": @":blue_book:",
                                 @"💣": @":bomb:",
                                 @"🔖": @":bookmark:",
                                 @"📑": @":bookmark_tabs:",
                                 @"📚": @":books:",
                                 @"👢": @":boot:",
                                 @"🎳": @":bowling:",
                                 @"🍞": @":bread:",
                                 @"💼": @":briefcase:",
                                 @"💡": @":bulb:",
                                 @"🍰": @":cake:",
                                 @"📆": @":calendar:",
                                 @"📲": @":calling:",
                                 @"📷": @":camera:",
                                 @"🍬": @":candy:",
                                 @"📇": @":card_index:",
                                 @"💿": @":cd:",
                                 @"📉": @":chart_with_downwards_trend:",
                                 @"📈": @":chart_with_upwards_trend:",
                                 @"🍒": @":cherries:",
                                 @"🍫": @":chocolate_bar:",
                                 @"🎄": @":christmas_tree:",
                                 @"🎬": @":clapper:",
                                 @"📋": @":clipboard:",
                                 @"📕": @":closed_book:",
                                 @"🔐": @":closed_lock_with_key:",
                                 @"🌂": @":closed_umbrella:",
                                 @"♣": @":clubs:",
                                 @"🍸": @":cocktail:",
                                 @"☕": @":coffee:",
                                 @"💻": @":computer:",
                                 @"🎊": @":confetti_ball:",
                                 @"🍪": @":cookie:",
                                 @"🌽": @":corn:",
                                 @"💳": @":credit_card:",
                                 @"👑": @":crown:",
                                 @"🔮": @":crystal_ball:",
                                 @"🍛": @":curry:",
                                 @"🍮": @":custard:",
                                 @"🍡": @":dango:",
                                 @"🎯": @":dart:",
                                 @"📅": @":date:",
                                 @"♦": @":diamonds:",
                                 @"💵": @":dollar:",
                                 @"🚪": @":door:",
                                 @"🍩": @":doughnut:",
                                 @"👗": @":dress:",
                                 @"📀": @":dvd:",
                                 @"📧": @":e-mail:",
                                 @"🍳": @":egg:",
                                 @"🍆": @":eggplant:",
                                 @"🔌": @":electric_plug:",
                                 @"✉": @":email:",
                                 @"💶": @":euro:",
                                 @"👓": @":eyeglasses:",
                                 @"📠": @":fax:",
                                 @"📁": @":file_folder:",
                                 @"🍥": @":fish_cake:",
                                 @"🎣": @":fishing_pole_and_fish:",
                                 @"🔦": @":flashlight:",
                                 @"💾": @":floppy_disk:",
                                 @"🎴": @":flower_playing_cards:",
                                 @"🏈": @":football:",
                                 @"🍴": @":fork_and_knife:",
                                 @"🍤": @":fried_shrimp:",
                                 @"🍟": @":fries:",
                                 @"🎲": @":game_die:",
                                 @"💎": @":gem:",
                                 @"🎁": @":gift:",
                                 @"⛳": @":golf:",
                                 @"🍇": @":grapes:",
                                 @"🍏": @":green_apple:",
                                 @"📗": @":green_book:",
                                 @"🎸": @":guitar:",
                                 @"🔫": @":gun:",
                                 @"🍔": @":hamburger:",
                                 @"🔨": @":hammer:",
                                 @"👜": @":handbag:",
                                 @"🎧": @":headphones:",
                                 @"♥": @":hearts:",
                                 @"🔆": @":high_brightness:",
                                 @"👠": @":high_heel:",
                                 @"🔪": @":hocho:",
                                 @"🍯": @":honey_pot:",
                                 @"🏇": @":horse_racing:",
                                 @"⌛": @":hourglass:",
                                 @"⏳": @":hourglass_flowing_sand:",
                                 @"🍨": @":ice_cream:",
                                 @"🍦": @":icecream:",
                                 @"📥": @":inbox_tray:",
                                 @"📨": @":incoming_envelope:",
                                 @"📱": @":iphone:",
                                 @"🏮": @":izakaya_lantern:",
                                 @"👖": @":jeans:",
                                 @"🔑": @":key:",
                                 @"👘": @":kimono:",
                                 @"📒": @":ledger:",
                                 @"🍋": @":lemon:",
                                 @"💄": @":lipstick:",
                                 @"🔒": @":lock:",
                                 @"🔏": @":lock_with_ink_pen:",
                                 @"🍭": @":lollipop:",
                                 @"➿": @":loop:",
                                 @"📢": @":loudspeaker:",
                                 @"🔅": @":low_brightness:",
                                 @"🔍": @":mag:",
                                 @"🔎": @":mag_right:",
                                 @"🀄": @":mahjong:",
                                 @"📫": @":mailbox:",
                                 @"📪": @":mailbox_closed:",
                                 @"📬": @":mailbox_with_mail:",
                                 @"📭": @":mailbox_with_no_mail:",
                                 @"👞": @":mans_shoe:",
                                 @"🍖": @":meat_on_bone:",
                                 @"📣": @":mega:",
                                 @"🍈": @":melon:",
                                 @"📝": @":memo:",
                                 @"🎤": @":microphone:",
                                 @"🔬": @":microscope:",
                                 @"💽": @":minidisc:",
                                 @"💸": @":money_with_wings:",
                                 @"💰": @":moneybag:",
                                 @"🚵": @":mountain_bicyclist:",
                                 @"🎥": @":movie_camera:",
                                 @"🎹": @":musical_keyboard:",
                                 @"🎼": @":musical_score:",
                                 @"🔇": @":mute:",
                                 @"📛": @":name_badge:",
                                 @"👔": @":necktie:",
                                 @"📰": @":newspaper:",
                                 @"🔕": @":no_bell:",
                                 @"📓": @":notebook:",
                                 @"📔": @":notebook_with_decorative_cover:",
                                 @"🔩": @":nut_and_bolt:",
                                 @"🍢": @":oden:",
                                 @"📂": @":open_file_folder:",
                                 @"📙": @":orange_book:",
                                 @"📤": @":outbox_tray:",
                                 @"📄": @":page_facing_up:",
                                 @"📃": @":page_with_curl:",
                                 @"📟": @":pager:",
                                 @"📎": @":paperclip:",
                                 @"🍑": @":peach:",
                                 @"🍐": @":pear:",
                                 @"✏": @":pencil2:",
                                 @"☎": @":phone:",
                                 @"💊": @":pill:",
                                 @"🍍": @":pineapple:",
                                 @"🍕": @":pizza:",
                                 @"📯": @":postal_horn:",
                                 @"📮": @":postbox:",
                                 @"👝": @":pouch:",
                                 @"🍗": @":poultry_leg:",
                                 @"💷": @":pound:",
                                 @"👛": @":purse:",
                                 @"📌": @":pushpin:",
                                 @"📻": @":radio:",
                                 @"🍜": @":ramen:",
                                 @"🎀": @":ribbon:",
                                 @"🍚": @":rice:",
                                 @"🍙": @":rice_ball:",
                                 @"🍘": @":rice_cracker:",
                                 @"💍": @":ring:",
                                 @"🏉": @":rugby_football:",
                                 @"🎽": @":running_shirt_with_sash:",
                                 @"🍶": @":sake:",
                                 @"👡": @":sandal:",
                                 @"📡": @":satellite:",
                                 @"🎷": @":saxophone:",
                                 @"✂": @":scissors:",
                                 @"📜": @":scroll:",
                                 @"💺": @":seat:",
                                 @"🍧": @":shaved_ice:",
                                 @"👕": @":shirt:",
                                 @"🚿": @":shower:",
                                 @"🎿": @":ski:",
                                 @"🚬": @":smoking:",
                                 @"🏂": @":snowboarder:",
                                 @"⚽": @":soccer:",
                                 @"🔉": @":sound:",
                                 @"👾": @":space_invader:",
                                 @"♠": @":spades:",
                                 @"🍝": @":spaghetti:",
                                 @"🔊": @":speaker:",
                                 @"🍲": @":stew:",
                                 @"📏": @":straight_ruler:",
                                 @"🍓": @":strawberry:",
                                 @"🏄": @":surfer:",
                                 @"🍣": @":sushi:",
                                 @"🍠": @":sweet_potato:",
                                 @"🏊": @":swimmer:",
                                 @"💉": @":syringe:",
                                 @"🎉": @":tada:",
                                 @"🎋": @":tanabata_tree:",
                                 @"🍊": @":tangerine:",
                                 @"🍵": @":tea:",
                                 @"📞": @":telephone_receiver:",
                                 @"🔭": @":telescope:",
                                 @"🎾": @":tennis:",
                                 @"🚽": @":toilet:",
                                 @"🍅": @":tomato:",
                                 @"🎩": @":tophat:",
                                 @"📐": @":triangular_ruler:",
                                 @"🏆": @":trophy:",
                                 @"🍹": @":tropical_drink:",
                                 @"🎺": @":trumpet:",
                                 @"📺": @":tv:",
                                 @"🔓": @":unlock:",
                                 @"📼": @":vhs:",
                                 @"📹": @":video_camera:",
                                 @"🎮": @":video_game:",
                                 @"🎻": @":violin:",
                                 @"⌚": @":watch:",
                                 @"🍉": @":watermelon:",
                                 @"🍷": @":wine_glass:",
                                 @"👚": @":womans_clothes:",
                                 @"👒": @":womans_hat:",
                                 @"🔧": @":wrench:",
                                 @"💴": @":yen:",
                                 @"🚡": @":aerial_tramway:",
                                 @"✈": @":airplane:",
                                 @"🚑": @":ambulance:",
                                 @"⚓": @":anchor:",
                                 @"🚛": @":articulated_lorry:",
                                 @"🏧": @":atm:",
                                 @"🏦": @":bank:",
                                 @"💈": @":barber:",
                                 @"🔰": @":beginner:",
                                 @"🚲": @":bike:",
                                 @"🚙": @":blue_car:",
                                 @"⛵": @":boat:",
                                 @"🌉": @":bridge_at_night:",
                                 @"🚅": @":bullettrain_front:",
                                 @"🚄": @":bullettrain_side:",
                                 @"🚌": @":bus:",
                                 @"🚏": @":busstop:",
                                 @"🚗": @":car:",
                                 @"🎠": @":carousel_horse:",
                                 @"🏁": @":checkered_flag:",
                                 @"⛪": @":church:",
                                 @"🎪": @":circus_tent:",
                                 @"🌇": @":city_sunrise:",
                                 @"🌆": @":city_sunset:",
                                 @"🚧": @":construction:",
                                 @"🏪": @":convenience_store:",
                                 @"🎌": @":crossed_flags:",
                                 @"🏬": @":department_store:",
                                 @"🏰": @":european_castle:",
                                 @"🏤": @":european_post_office:",
                                 @"🏭": @":factory:",
                                 @"🎡": @":ferris_wheel:",
                                 @"🚒": @":fire_engine:",
                                 @"⛲": @":fountain:",
                                 @"⛽": @":fuelpump:",
                                 @"🚁": @":helicopter:",
                                 @"🏥": @":hospital:",
                                 @"🏨": @":hotel:",
                                 @"♨": @":hotsprings:",
                                 @"🏠": @":house:",
                                 @"🏡": @":house_with_garden:",
                                 @"🗾": @":japan:",
                                 @"🏯": @":japanese_castle:",
                                 @"🚈": @":light_rail:",
                                 @"🏩": @":love_hotel:",
                                 @"🚐": @":minibus:",
                                 @"🚝": @":monorail:",
                                 @"🗻": @":mount_fuji:",
                                 @"🚠": @":mountain_cableway:",
                                 @"🚞": @":mountain_railway:",
                                 @"🗿": @":moyai:",
                                 @"🏢": @":office:",
                                 @"🚘": @":oncoming_automobile:",
                                 @"🚍": @":oncoming_bus:",
                                 @"🚔": @":oncoming_police_car:",
                                 @"🚖": @":oncoming_taxi:",
                                 @"🎭": @":performing_arts:",
                                 @"🚓": @":police_car:",
                                 @"🏣": @":post_office:",
                                 @"🚃": @":railway_car:",
                                 @"🌈": @":rainbow:",
                                 @"🚀": @":rocket:",
                                 @"🎢": @":roller_coaster:",
                                 @"🚨": @":rotating_light:",
                                 @"📍": @":round_pushpin:",
                                 @"🚣": @":rowboat:",
                                 @"🏫": @":school:",
                                 @"🚢": @":ship:",
                                 @"🎰": @":slot_machine:",
                                 @"🚤": @":speedboat:",
                                 @"🌠": @":stars:",
                                 @"🌃": @":city-night:",
                                 @"🚉": @":station:",
                                 @"🗽": @":statue_of_liberty:",
                                 @"🚂": @":steam_locomotive:",
                                 @"🌅": @":sunrise:",
                                 @"🌄": @":sunrise_over_mountains:",
                                 @"🚟": @":suspension_railway:",
                                 @"🚕": @":taxi:",
                                 @"⛺": @":tent:",
                                 @"🎫": @":ticket:",
                                 @"🗼": @":tokyo_tower:",
                                 @"🚜": @":tractor:",
                                 @"🚥": @":traffic_light:",
                                 @"🚆": @":train2:",
                                 @"🚊": @":tram:",
                                 @"🚩": @":triangular_flag_on_post:",
                                 @"🚎": @":trolleybus:",
                                 @"🚚": @":truck:",
                                 @"🚦": @":vertical_traffic_light:",
                                 @"⚠": @":warning:",
                                 @"💒": @":wedding:",
                                 @"🇯🇵": @":jp:",
                                 @"🇰🇷": @":kr:",
                                 @"🇨🇳": @":cn:",
                                 @"🇺🇸": @":us:",
                                 @"🇫🇷": @":fr:",
                                 @"🇪🇸": @":es:",
                                 @"🇮🇹": @":it:",
                                 @"🇷🇺": @":ru:",
                                 @"🇬🇧": @":gb:",
                                 @"🇩🇪": @":de:",
                                 @"💯": @":100:",
                                 @"🔢": @":1234:",
                                 @"🅰": @":a:",
                                 @"🆎": @":ab:",
                                 @"🔤": @":abc:",
                                 @"🔡": @":abcd:",
                                 @"🉑": @":accept:",
                                 @"♒": @":aquarius:",
                                 @"♈": @":aries:",
                                 @"◀": @":arrow_backward:",
                                 @"⏬": @":arrow_double_down:",
                                 @"⏫": @":arrow_double_up:",
                                 @"⬇": @":arrow_down:",
                                 @"🔽": @":arrow_down_small:",
                                 @"▶": @":arrow_forward:",
                                 @"⤵": @":arrow_heading_down:",
                                 @"⤴": @":arrow_heading_up:",
                                 @"⬅": @":arrow_left:",
                                 @"↙": @":arrow_lower_left:",
                                 @"↘": @":arrow_lower_right:",
                                 @"➡": @":arrow_right:",
                                 @"↪": @":arrow_right_hook:",
                                 @"⬆": @":arrow_up:",
                                 @"↕": @":arrow_up_down:",
                                 @"🔼": @":arrow_up_small:",
                                 @"↖": @":arrow_upper_left:",
                                 @"↗": @":arrow_upper_right:",
                                 @"🔃": @":arrows_clockwise:",
                                 @"🔄": @":arrows_counterclockwise:",
                                 @"🅱": @":b:",
                                 @"🚼": @":baby_symbol:",
                                 @"🛄": @":baggage_claim:",
                                 @"☑": @":ballot_box_with_check:",
                                 @"‼": @":bangbang:",
                                 @"⚫": @":black_circle:",
                                 @"🔲": @":black_square_button:",
                                 @"♋": @":cancer:",
                                 @"🔠": @":capital_abcd:",
                                 @"♑": @":capricorn:",
                                 @"💹": @":chart:",
                                 @"🚸": @":children_crossing:",
                                 @"🎦": @":cinema:",
                                 @"🆑": @":cl:",
                                 @"🕐": @":clock1:",
                                 @"🕙": @":clock10:",
                                 @"🕥": @":clock1030:",
                                 @"🕚": @":clock11:",
                                 @"🕦": @":clock1130:",
                                 @"🕛": @":clock12:",
                                 @"🕧": @":clock1230:",
                                 @"🕜": @":clock130:",
                                 @"🕑": @":clock2:",
                                 @"🕝": @":clock230:",
                                 @"🕒": @":clock3:",
                                 @"🕞": @":clock330:",
                                 @"🕓": @":clock4:",
                                 @"🕟": @":clock430:",
                                 @"🕔": @":clock5:",
                                 @"🕠": @":clock530:",
                                 @"🕕": @":clock6:",
                                 @"🕡": @":clock630:",
                                 @"🕖": @":clock7:",
                                 @"🕢": @":clock730:",
                                 @"🕗": @":clock8:",
                                 @"🕣": @":clock830:",
                                 @"🕘": @":clock9:",
                                 @"🕤": @":clock930:",
                                 @"㊗": @":congratulations:",
                                 @"🆒": @":cool:",
                                 @"©": @":copyright:",
                                 @"➰": @":curly_loop:",
                                 @"💱": @":currency_exchange:",
                                 @"🛃": @":customs:",
                                 @"💠": @":diamond_shape_with_a_dot_inside:",
                                 @"🚯": @":do_not_litter:",
                                 @"8⃣": @":eight:",
                                 @"✴": @":eight_pointed_black_star:",
                                 @"✳": @":eight_spoked_asterisk:",
                                 @"🔚": @":end:",
                                 @"⏩": @":fast_forward:",
                                 @"5⃣": @":five:",
                                 @"4⃣": @":four:",
                                 @"🆓": @":free:",
                                 @"♊": @":gemini:",
                                 @"#⃣": @":hash:",
                                 @"💟": @":heart_decoration:",
                                 @"✔": @":heavy_check_mark:",
                                 @"➗": @":heavy_division_sign:",
                                 @"💲": @":heavy_dollar_sign:",
                                 @"➖": @":heavy_minus_sign:",
                                 @"✖": @":heavy_multiplication_x:",
                                 @"➕": @":heavy_plus_sign:",
                                 @"🆔": @":id:",
                                 @"🉐": @":ideograph_advantage:",
                                 @"ℹ": @":information_source:",
                                 @"⁉": @":interrobang:",
                                 @"🔟": @":keycap_ten:",
                                 @"🈁": @":koko:",
                                 @"🔵": @":large_blue_circle:",
                                 @"🔷": @":large_blue_diamond:",
                                 @"🔶": @":large_orange_diamond:",
                                 @"🛅": @":left_luggage:",
                                 @"↔": @":left_right_arrow:",
                                 @"↩": @":leftwards_arrow_with_hook:",
                                 @"♌": @":leo:",
                                 @"♎": @":libra:",
                                 @"🔗": @":link:",
                                 @"Ⓜ": @":m:",
                                 @"🚹": @":mens:",
                                 @"🚇": @":metro:",
                                 @"📴": @":mobile_phone_off:",
                                 @"❎": @":negative_squared_cross_mark:",
                                 @"🆕": @":new:",
                                 @"🆖": @":ng:",
                                 @"9⃣": @":nine:",
                                 @"🚳": @":no_bicycles:",
                                 @"⛔": @":no_entry:",
                                 @"🚫": @":no_entry_sign:",
                                 @"📵": @":no_mobile_phones:",
                                 @"🚷": @":no_pedestrians:",
                                 @"🚭": @":no_smoking:",
                                 @"🚱": @":non-potable_water:",
                                 @"⭕": @":o:",
                                 @"🅾": @":o2:",
                                 @"🆗": @":ok:",
                                 @"🔛": @":on:",
                                 @"1⃣": @":one:",
                                 @"⛎": @":ophiuchus:",
                                 @"🅿": @":parking:",
                                 @"〽": @":part_alternation_mark:",
                                 @"🛂": @":passport_control:",
                                 @"♓": @":pisces:",
                                 @"🚰": @":potable_water:",
                                 @"🚮": @":put_litter_in_its_place:",
                                 @"🔘": @":radio_button:",
                                 @"♻": @":recycle:",
                                 @"🔴": @":red_circle:",
                                 @"®": @":registered:",
                                 @"🔁": @":repeat:",
                                 @"🔂": @":repeat_one:",
                                 @"🚻": @":restroom:",
                                 @"⏪": @":rewind:",
                                 @"🈂": @":sa:",
                                 @"♐": @":sagittarius:",
                                 @"♏": @":scorpius:",
                                 @"㊙": @":secret:",
                                 @"7⃣": @":seven:",
                                 @"📶": @":signal_strength:",
                                 @"6⃣": @":six:",
                                 @"🔯": @":six_pointed_star:",
                                 @"🔹": @":small_blue_diamond:",
                                 @"🔸": @":small_orange_diamond:",
                                 @"🔺": @":small_red_triangle:",
                                 @"🔻": @":small_red_triangle_down:",
                                 @"🔜": @":soon:",
                                 @"🆘": @":sos:",
                                 @"🔣": @":symbols:",
                                 @"♉": @":taurus:",
                                 @"3⃣": @":three:",
                                 @"™": @":tm:",
                                 @"🔝": @":top:",
                                 @"🔱": @":trident:",
                                 @"🔀": @":twisted_rightwards_arrows:",
                                 @"2⃣": @":two:",
                                 @"🈹": @":u5272:",
                                 @"🈴": @":u5408:",
                                 @"🈺": @":u55b6:",
                                 @"🈯": @":u6307:",
                                 @"🈷": @":u6708:",
                                 @"🈶": @":u6709:",
                                 @"🈵": @":u6e80:",
                                 @"🈚": @":u7121:",
                                 @"🈸": @":u7533:",
                                 @"🈲": @":u7981:",
                                 @"🈳": @":u7a7a:",
                                 @"🔞": @":underage:",
                                 @"🆙": @":up:",
                                 @"📳": @":vibration_mode:",
                                 @"♍": @":virgo:",
                                 @"🆚": @":vs:",
                                 @"〰": @":wavy_dash:",
                                 @"🚾": @":wc:",
                                 @"♿": @":wheelchair:",
                                 @"✅": @":white_check_mark:",
                                 @"⚪": @":white_circle:",
                                 @"💮": @":white_flower:",
                                 @"🔳": @":white_square_button:",
                                 @"🚺": @":womens:",
                                 @"❌": @":x:",
                                 @"0⃣": @":zero:"
                                 };
    
    NSMutableDictionary *reversedMap = [NSMutableDictionary dictionaryWithCapacity:[forwardMap count]];
    [forwardMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            for (NSString *object in obj) {
                [reversedMap setObject:key forKey:object];
            }
        } else {
            [reversedMap setObject:key forKey:obj];
        }
    }];
    
    @synchronized(self) {
        s_unicodeToCheatCodes = forwardMap;
        s_cheatCodesToUnicode = [reversedMap copy];
    }
}

//内容找出对应的笑脸
- (NSString *)stringByReplacingEmojiCheatCodesWithUnicode{
    if (!s_cheatCodesToUnicode) {
        [NSString initializeEmojiCheatCodes];
    }
    
    if ([self rangeOfString:@":"].location != NSNotFound) {
        __block NSMutableString *newText = [NSMutableString stringWithString:self];
        [s_cheatCodesToUnicode enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            [newText replaceOccurrencesOfString:key withString:obj options:NSLiteralSearch range:NSMakeRange(0, newText.length)];
        }];
        return newText;
    }
    return self;
}

- (NSString *)encodeUrl{
    NSString *charactersToEscape = @":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *newString = [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    
//    NSString *newString = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)url, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    
    if(newString){
        return newString;
    }
    return self;
}

//笑脸找出对应的内容
- (NSString *)stringByReplacingEmojiUnicodeWithCheatCodes{
    if (!s_cheatCodesToUnicode) {
        [NSString initializeEmojiCheatCodes];
    }
    
    if (self.length) {
        __block NSMutableString *newText = [NSMutableString stringWithString:self];
        [s_unicodeToCheatCodes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *string = ([obj isKindOfClass:[NSArray class]] ? [obj firstObject] : obj);
            [newText replaceOccurrencesOfString:key withString:string options:NSLiteralSearch range:NSMakeRange(0, newText.length)];
        }];
        return newText;
    }
    return self;
}

- (NSString *)addingPercentEscapesUsingEncoding{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString *)replacingPercentEscapesUsingEncoding{
    return [self stringByRemovingPercentEncoding];
}

- (NSString *)replaceUnicode {
    NSString *tempStr1 = [self stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1   stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *returnStr = [NSPropertyListSerialization propertyListWithData:tempData
                                                                    options:NSPropertyListImmutable
                                                                     format:nil
                                                                      error:nil];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

//字符串 转Unicode
+ (NSString *)utf8ToUnicode:(NSString *)string{
    NSUInteger length = [string length];
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++){
        NSMutableString *s = [NSMutableString stringWithCapacity:0];
        unichar _char = [string characterAtIndex:i];
        // 判断是否为英文和数字
        if (_char <= '9' && _char >='0'){
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }else if(_char >='a' && _char <= 'z'){
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }else if(_char >='A' && _char <= 'Z'){
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }else{
            // 中文和字符
            [s appendFormat:@"\\u%x",[string characterAtIndex:i]];
            // 不足位数补0 否则解码不成功
            if(s.length == 4) {
                [s insertString:@"00" atIndex:2];
            } else if (s.length == 5) {
                [s insertString:@"0" atIndex:2];
            }
        }
        [str appendFormat:@"%@", s];
    }
    return str;
}

//Unicode 转字符串
+ (NSString *)replaceUnicode:(NSString *)unicodeStr{
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\r\n"withString:@"\n"];
}

- (BOOL)pd_stringContainsEmoji{
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              const unichar high = [substring characterAtIndex: 0];
                              // Surrogate pair (U+1D000-1F9FF)
                              if (0xD800 <= high && high <= 0xDBFF) {
                                  const unichar low = [substring characterAtIndex: 1];
                                  const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                  if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                      returnValue = YES;
                                  }
                                  // Not surrogate pair (U+2100-27BF)
                              } else {
                                  if (0x2100 <= high && high <= 0x27BF){
                                      returnValue = YES;
                                  }
                              }
                          }];
    return returnValue;
}

- (instancetype)pd_removedEmojiString {
    NSMutableString* __block buffer = [NSMutableString stringWithCapacity:[self length]];
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                              [buffer appendString:([substring pd_stringContainsEmoji])? @"": substring];
                          }];
    
    return buffer;
}


- (NSString *)leftStripInPlace{
    NSInteger i;
    for(i = 0;i < self.length;i++){
        if(![[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[self characterAtIndex:i]]){
            break;
        }
    }
    return [self stringByReplacingCharactersInRange:NSMakeRange(0, i) withString:@""];
}

- (NSString *)rightStripInPlace{
    NSInteger i;
    for(i = self.length - 1;i > 0;i--){
        if(![[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[self characterAtIndex:i]]){
            break;
        }
    }
    return [self stringByReplacingCharactersInRange:NSMakeRange(i + 1, self.length - 1 - i) withString:@""];
}

- (NSString *)stripInPlace{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)reverseString{
    NSMutableString* reverseString = [[NSMutableString alloc] init];
    NSInteger charIndex = [self length];
    while (charIndex > 0) {
        charIndex --;
        NSRange subStrRange = NSMakeRange(charIndex, 1);
        [reverseString appendString:[self substringWithRange:subStrRange]];
    }
    return reverseString;
}

//把第一次出现的什么转换成什么，后面出现的不转换
- (NSString *)substituteFirstInPlace:(NSString *)pattern with:(NSString *)sub{
    NSString *result = self;
    NSError *error = nil;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:&error];
    if(!error) {
        NSTextCheckingResult *match = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
        result = [result stringByReplacingCharactersInRange:match.range withString:sub];
    }
    return result;
}

//把最后一次出现的什么转换成什么，前面出现的不转换
- (NSString *)substituteLastInPlace:(NSString *)pattern with:(NSString *)sub{
    NSString *result = self;
    NSError *error = nil;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:&error];
    if(!error) {
        NSTextCheckingResult *match = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)].lastObject;
        result = [result stringByReplacingCharactersInRange:match.range withString:sub];
    }
    return result;
}

- (NSString *)stringByReplacingAllInPlace:(NSString *)pattern with:(NSString *)sub{
    return [self stringByReplacingOccurrencesOfString:pattern withString:sub];
}

+ (NSMutableDictionary *)getURLParameters:(NSString *)urlStr {
    // 查找参数
    NSRange range = [urlStr rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    // 以字典形式将参数返回
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 截取参数
    NSString *parametersString = [urlStr substringFromIndex:range.location + 1];
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            id existValue = [params valueForKey:key];
            if (existValue != nil) {
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
            } else {
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        // 设置值
        [params setValue:value forKey:key];
    }
    return params;
}

+ (NSString *)lgf_FileSizeFormat:(CGFloat)bsize {
    if (bsize < 1024) {
        return [NSString stringWithFormat:@"%0.1fB", bsize];
    } else if (bsize < 1024 * 1024) {
        return [NSString stringWithFormat:@"%0.1fKB", bsize / 1024];
    } else if (bsize < 1024 * 1024 * 1024) {
        return [NSString stringWithFormat:@"%0.1fMB", bsize / (1024 * 1024)];
    }
    return [NSString stringWithFormat:@"%0.1fGB", bsize / (1024 * 1024 * 1024)];
}

- (BOOL)isOnlyHaveSmallLetters {
    NSInteger alength = [self length];
    for (int i = 0; i<alength; i++) {
        char commitChar = [self characterAtIndex:i];
        if ((commitChar > 64) && (commitChar < 91)) {
            NSLog(@"字符串中含有大写英文字母");
            return NO;
        }
    }
    return YES;
}
- (BOOL)isOnlyHaveCapitalLetters {
    NSInteger alength = [self length];
    for (int i = 0; i<alength; i++) {
        char commitChar = [self characterAtIndex:i];
        if ((commitChar > 96) && (commitChar < 123)) {
            NSLog(@"字符串中含有小写英文字母");
            return NO;
        }
    }
    return YES;
}

//小写字母转换成大写，大写字母转换成小写
- (NSString *)swapcaseInPlace{
    if (self.length == 0){
        return self;
    }
    NSMutableString *string = [NSMutableString string];
    for (NSUInteger i = 0; i < self.length; i++) {
        NSString *cString = [self substringWithRange:NSMakeRange(i, 1)];
        NSString *cStringLower = [cString lowercaseString];
        if ([cString isEqualToString:cStringLower]) {
            cStringLower = [cString uppercaseString];
        }
        [string appendString:cStringLower];
    }
    return string;
}

//字母转成成大写
- (NSString *)uppercaseInPlace{
    return  [self uppercaseString];
}

//字母转成成小写
- (NSString *)lowercaseInPlace{
    return  [self lowercaseString];
}

- (NSString *)mj_underlineFromCamel{
    if (self.length == 0){
        return self;
    }
    NSMutableString *string = [NSMutableString string];
    for (NSUInteger i = 0; i < self.length; i++) {
        NSString *cString = [self substringWithRange:NSMakeRange(i, 1)];
        NSString *cStringLower = [cString lowercaseString];
        if ([cString isEqualToString:cStringLower]) {
            [string appendString:cStringLower];
        } else {
            [string appendString:@"_"];
            [string appendString:cStringLower];
        }
    }
    return string;
}

- (NSString *)mj_camelFromUnderline{
    if (self.length == 0){
        return self;
    }
    NSMutableString *string = [NSMutableString string];
    NSArray *cmps = [self componentsSeparatedByString:@"_"];
    for (NSUInteger i = 0; i < cmps.count; i++) {
        NSString *cmp = cmps[i];
        if (i && cmp.length) {
            [string appendString:[[cmp substringToIndex:1] uppercaseString]];
            if (cmp.length >= 2){
                [string appendString:[cmp substringFromIndex:1]];
            }
        } else {
            [string appendString:cmp];
        }
    }
    return string;
}

// 字典转json字符串方法
+ (NSString *)convertToJsonData:(NSDictionary *)dict{
    NSError *error;
    NSString *jsonString;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if (jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        NSLog(@"%@",error);
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

+ (NSDictionary *)dictionaryWithJsonString:(id _Nullable)JSON{
    if (!JSON || JSON == (id)kCFNull){
        return nil;
    }
    NSDictionary *JSON2Dictionary = nil;
    NSData *jsonData = nil;
    NSError *err;
    if ([JSON isKindOfClass:[NSDictionary class]]) {
        JSON2Dictionary = JSON;
    } else if ([JSON isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)JSON dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([JSON isKindOfClass:[NSData class]]) {
        jsonData = JSON;
    }
    if (jsonData) {
//        JSON2Dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        JSON2Dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&err];
        if (err || ![JSON2Dictionary isKindOfClass:[NSDictionary class]]){
            JSON2Dictionary = nil;
            NSLog(@"json解析失败：%@",err);
        }
    }
    return JSON2Dictionary;
}

- (NSString *)mj_firstCharLower{
    if (self.length == 0){
        return self;
    }
    NSMutableString *string = [NSMutableString string];
    [string appendString:[[self substringToIndex:1] lowercaseString]];
    if (self.length >= 2){
        [string appendString:[self substringFromIndex:1]];
    }
    return string;
}

- (NSString *)mj_firstCharUpper{
    if (self.length == 0){
        return self;
    }
    NSMutableString *string = [NSMutableString string];
    [string appendString:[[self substringToIndex:1] uppercaseString]];
    if (self.length >= 2){
        [string appendString:[self substringFromIndex:1]];
    }
    return string;
}

- (BOOL)mj_isPureInt{
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

+ (NSString *)pd_JsonStringSplitWithDic:(NSDictionary *)splitDic{
    NSString *jsonString = nil;
    if ([splitDic isKindOfClass:[NSDictionary class]]) {
        jsonString = [NSString JsonString:jsonString SplitDic:splitDic];
    }
    jsonString = [jsonString substringToIndex:jsonString.length - 1];
    return jsonString;
}

+ (NSString *)JsonString:(NSString *)jsonString SplitDic:(NSDictionary *)splitDic{
    __block NSString *jsonStr = jsonString;
    NSArray *keyArray = [splitDic allKeys];
    [keyArray enumerateObjectsUsingBlock:^(NSString *keyStr, NSUInteger idx, BOOL * _Nonnull stop) {
        id tempObject = [splitDic valueForKey:keyStr];
        if ([tempObject isKindOfClass:[NSString class]]) {
            if (jsonStr == nil) {
                jsonStr = [keyStr stringByAppendingString:@"="];
            }else{
                jsonStr = [jsonStr stringByAppendingString:keyStr];
                jsonStr = [jsonStr stringByAppendingString:@"="];
            }
            jsonStr = [jsonStr stringByAppendingString:tempObject];
            jsonStr = [jsonStr stringByAppendingString:@"&"];
        }else if([tempObject isKindOfClass:[NSDictionary class]]){
            jsonStr = [NSString JsonString:jsonStr SplitDic:tempObject];
        }
    }];
    return jsonStr;
}

+ (NSString *)generateGETAbsoluteURL:(NSString *)url
                              params:(id)params{
    NSString *paramsUrlStr = [self pd_JsonStringSplitWithDic:params];
    if (url == nil) {
        return paramsUrlStr;
    }else {
        if (paramsUrlStr == nil) {
            return url;
        }else{
            if([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]){
                if([url rangeOfString:@"?"].location != NSNotFound || [url rangeOfString:@"#"].location != NSNotFound){
                    url = [NSString stringWithFormat:@"%@%@",url,paramsUrlStr];
                }else{
                    paramsUrlStr = [paramsUrlStr substringFromIndex:1];
                    url = [NSString stringWithFormat:@"%@?%@",url,paramsUrlStr];
                }
            }
            return url;
        }
    }
}

/**
 *  @brief 是否包含字符串
 *
 *  @param string 字符串
 *
 *  @return YES, 包含; Otherwise
 */
- (BOOL)containsaString:(NSString *)string{
    NSRange rang = [self rangeOfString:string];
    if (rang.location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}

- (NSString *)urlEncodedString {
    CFStringRef encodedCFString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                          (__bridge CFStringRef) self,
                                                                          nil,
                                                                          CFSTR("?!@#$^&%*+,:;='\"`<>()[]{}/\\| "),
                                                                          kCFStringEncodingUTF8);
    NSString *encodedString = [[NSString alloc] initWithString:(__bridge_transfer NSString *)encodedCFString];
    if(!encodedString){
        encodedString = @"";
    }
    return encodedString;
}

- (NSString *)urlDecodedString {
    CFStringRef decodedCFString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                          (__bridge CFStringRef) self,
                                                                                          CFSTR(""),
                                                                                          kCFStringEncodingUTF8);
    NSString *decodedString = [[NSString alloc] initWithString:(__bridge_transfer NSString *)decodedCFString];
    return (!decodedString) ? @"" : [decodedString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
}


+ (NSString *)wh_translation:(NSString *)arebic{
    NSString *str = arebic;
    NSArray *arabic_numerals = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chinese_numerals = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
    NSMutableArray *sums = [NSMutableArray array];
    for (int i = 0; i < str.length; i ++) {
        NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *a = [dictionary objectForKey:substr];
        NSString *b = digits[str.length -i-1];
        NSString *sum = [a stringByAppendingString:b];
        if ([a isEqualToString:chinese_numerals[9]]){
            if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]]){
                sum = b;
                if ([[sums lastObject] isEqualToString:chinese_numerals[9]]){
                    [sums removeLastObject];
                }
            }else{
                sum = chinese_numerals[9];
            }
            if ([[sums lastObject] isEqualToString:sum]){
                continue;
            }
        }
        [sums addObject:sum];
    }
    NSString *sumStr = [sums componentsJoinedByString:@""];
    NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
    return chinese;
}

+ (BOOL)stringInArray:(NSArray *)source string:(NSString *)string{
    BOOL founded = NO;
    for (int strIdx = 0; strIdx < [source count]; strIdx++) {
        id value = [source objectAtIndex:strIdx];
        if ([value isKindOfClass:[NSString class]]) {
            founded = [string isEqualToString:(NSString *)value];
            if (founded) {
                break;
            }
        }
    }
    return founded;
}

/* 搜索两个字符之间的字符串 */
+ (NSString *)searchInString:(NSString *)string charStart:(char)start charEnd:(char)end{
    int inizio = 0;
    int stop = 0;
    for(int i = 0; i < [string length]; i++){
        // 定位起点索引字符
        if([string characterAtIndex:i] == start){
            inizio = i + 1;
            i += 1;
        }
        // 定位结束索引字符
        if([string characterAtIndex:i] == end){
            stop = i;
            break;
        }
    }
    stop -= inizio;
    // 裁剪字符串
    NSString *string2 = [[string substringFromIndex:inizio - 1] substringToIndex:stop + 1];
    return string2;
}

/**
 *  @brief 获取字符数量
 */
- (int)wordsCount{
    NSInteger n = self.length;
    int i;
    int l = 0, a = 0, b = 0;
    unichar c;
    for (i = 0; i < n; i++){
        c = [self characterAtIndex:i];
        if (isblank(c)) {
            b++;
        } else if (isascii(c)) {
            a++;
        } else {
            l++;
        }
    }
    if (a == 0 && l == 0) {
        return 0;
    }
    return l + (int)ceilf((float)(a + b) / 2.0);
}

- (NSUInteger)ba_getLength{
    NSUInteger asciiLength = 0;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *da = [self dataUsingEncoding:enc];
    asciiLength = [da length];
    
    //或者
    //    NSLog(@"%lu",[str lengthOfBytesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)]);
    
    //或者  如果这个字符串（@"我12☺34"）上面方法返回10，此方法放回8
    //    for (NSUInteger i = 0; i < str.length; i++) {
    //        unichar uc = [str characterAtIndex: i];
    //        asciiLength += isascii(uc) ? 1 : 2;
    //    }
    
    //或者
    //    char *p = (char *)[str cStringUsingEncoding:NSUnicodeStringEncoding];
    //    for (int i = 0 ; i < [str lengthOfBytesUsingEncoding:NSUnicodeStringEncoding];i++) {
    //        if (*p) {
    //            asciiLength ++;
    //        }
    //        p ++;
    //    }
    return asciiLength;
}

- (NSArray <NSValue *> *)ba_rangesOfString:(NSString *)searchString options:(NSStringCompareOptions)mask serachRange:(NSRange)range{
    if (range.location + range.length > self.length) {
        return nil;
    }
    NSMutableArray *array = [NSMutableArray array];
    [self ba_rangeOfString:searchString options:mask range:range array:array];
    return array;
}

- (void)ba_rangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask range:(NSRange)searchRange array:(NSMutableArray *)array{
    NSRange range = [self rangeOfString:searchString options:mask range:searchRange];
    if (range.location != NSNotFound) {
        [array addObject:[NSValue valueWithRange:range]];
        [self ba_rangeOfString:searchString options:mask range:NSMakeRange(range.location + range.length, self.length - (range.location + range.length)) array:array];
    }
}

- (NSString *)ba_phoneNumberFormatterSpace{
    NSString *phone = self;
    while (phone.length > 0){
        NSString *subString = [phone substringToIndex:MIN(phone.length, 3)];
        if (phone.length >= 7 ){
            subString = [subString stringByAppendingString:@" "];
            subString = [subString stringByAppendingString:[phone substringWithRange:NSMakeRange(3, 4)]];
        }
        if ( phone.length == 11 ){
            subString = [subString stringByAppendingString:@" "];
            subString = [subString stringByAppendingString:[phone substringWithRange:NSMakeRange(7, 4)]];
            phone = subString;
            break;
        }
    }
    return phone;
}

- (NSString *)ba_phoneNumberFormatterCenterStar{
    NSString *phone = self;
    while (phone.length > 0){
        phone = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        break;
    }
    return phone;
}

+ (NSString *)ba_stringFormatterWithStyle:(NSNumberFormatterStyle)numberStyle
                                   number:(NSNumber *)value{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = numberStyle;
    NSString *changeString = @"";
    switch (numberStyle) {
        case NSNumberFormatterNoStyle:
        {
            //小数位最少保留10位小数
            formatter.minimumFractionDigits = 10;
            changeString = [formatter stringFromNumber:value];
        }
            break;
        case NSNumberFormatterCurrencyStyle:
        {
            //接收的货币分组分隔符 只有NSNumberFormatterCurrencyStyle下才有用(默认是,改成//)
            formatter.currencyGroupingSeparator = @"//";
            changeString = [formatter stringFromNumber:value];
        }
            break;
        case NSNumberFormatterPercentStyle:
        {
            //将12.3生成12.3%
            //缩放因子,你可以将一个数缩放指定比例,然后给其添加后缀
            //缩放因子,你可以将一个数缩放指定比例,然后给其添加后缀,如传入一个3000,你希望表示为3千,就要用到这个属性
            //    formatter.multiplier = @1000;
            //    NSLog(@"%@千",[formatter numberFromString:@"1000"]);  // 1千
            
            //   formatter.multiplier     = @0.001;
            //   formatter.positiveSuffix = @"千";
            //   NSLog(@"%@",[formatter stringFromNumber:@10000]);    // 10千
            formatter.multiplier = @1.0f;
            //接收器用来表示百分比符号的字符串。(默认是%,改成%%)
            formatter.percentSymbol = @"百分之";
            //最少保留2位小数点
            formatter.minimumFractionDigits = 2;
            changeString = [formatter stringFromNumber:value];
        }
            break;
        case NSNumberFormatterScientificStyle:
        {
            //接收器用来表示指数符号的字符串 (默认是E)。
            formatter.exponentSymbol = @"ee";
            //        formatter.currencyCode                     // 货币代码USD
            //        formatter.currencySymbol                   // 货币符号$
            //        formatter.internationalCurrencySymbol   // 国际货币符号USD
            //        formatter.perMillSymbol                   // 千分号符号‰
            //        formatter.minusSign                         // 减号符号-
            //        formatter.plusSign                          // 加号符号+
            changeString = [formatter stringFromNumber:value];
        }
            break;
        case NSNumberFormatterSpellOutStyle:
        {
            //将数值0改成零
            formatter.zeroSymbol = @"零";
            changeString = [formatter stringFromNumber:value];
        }
            break;
        case NSNumberFormatterDecimalStyle:
        {
            //            //1.如果是负数的时候的前缀 用这个字符串代替默认的"-"号
            //            //formatter.positivePrefix = @"!";
            //            //formatter.negativeSuffix = @"亏";
            //            formatter.negativePrefix = @"负数";
            
            //            //2.更改小数点样式
            //            formatter.decimalSeparator = @"。";
            
            //            //3.数字分割的尺寸 就比如数字越多1234 为了方便就分割开 1,234(这个分割的大小是3) 从后往前数
            //            formatter.groupingSize = 2;
            //            //一些区域允许较大的数字的另一个分组大小的规范。例如，有些地方可能代表一个数字如61，242，378.46（在美国）作为6,12, 42378.46。在这种情况下，二次分组大小（覆盖小数点最远的数字组）为2
            //            //小数点前的(大于零的部分)，先从右往左分割groupSize的，如果剩余的在按照secondaryGroupingSize的大小来分
            //            formatter.secondaryGroupingSize = 1;
            
            //            //4.格式宽度 出来的数据占位是15个 例如是 123,45.6 格式宽度就是 8
            //            formatter.formatWidth = 15;
            //            //填充符 有时候格式宽度够宽，不够就用填充符*填充
            //            formatter.paddingCharacter = @"*";
            //            //填充符的位置
            //            formatter.paddingPosition = kCFNumberFormatterPadAfterSuffix;
            
//            //5.舍入方式
//            formatter.roundingMode = NSNumberFormatterRoundHalfUp;
//            // 舍入值 比如以1为进位值   123456.58 变为 123457
//            formatter.roundingIncrement = @1;
            
            //6.字符串转成金钱格式  如 57823092.9  结果 57,823,092.90
            formatter.positiveFormat = @"###,##0.00";
            
            changeString = [formatter stringFromNumber:value];
        }
            break;
            // 整数最多位数
            //    changeFormatter.maximumIntegerDigits = 10;
            //    // 整数最少位数
            //    changeFormatter.minimumIntegerDigits = 2;
            //    // 小数位最多位数
            //    changeFormatter.maximumFractionDigits = 3;
            //    // 最大有效数字个数
            //    changeFormatter.maximumSignificantDigits = 12;
            //    // 最少有效数字个数
            //    changeFormatter.minimumSignificantDigits = 3;
        default:
            break;
    }
    return changeString;
}

- (NSString *)ba_removeStringSaveNumber{
    NSCharacterSet *setToRemove = [[ NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return [[self componentsSeparatedByCharactersInSet:setToRemove] componentsJoinedByString:@""];
}

- (BOOL)isVAlidateNumber:(NSString *)number{
    NSString *qqRegex = @"^\\d*$";
    return [self isValidateByRegex:qqRegex];
}

//手机号分服务商
- (BOOL)isMobileNumberClassification{
    /**
     * 手机号码:
     * 13[0-9], 14[0,4-9], 15[0-3, 5-9], 16[5-7],17[0-8], 18[0-9], 19[1,3,8,9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[04-9]|5[0-35-9]|6[5-7]|7[0-8]|8[0-9]|9[1389])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // 带区号
    NSString *PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    //不带区号
    NSString *PHSN = @"^[1-9]{1}[0-9]{5,8}$";
    if (([self isValidateByRegex:MOBILE]) || ([self isValidateByRegex:CM]) || ([self isValidateByRegex:CU]) || ([self isValidateByRegex:CT]) || ([self isValidateByRegex:PHS]) || ([self isValidateByRegex:PHSN])){
        return YES;
    } else{
        return NO;
    }
}

//邮箱
- (BOOL)isEmailAddress{
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self isValidateByRegex:emailRegex];
}

//精确的身份证号码有效性检测
- (BOOL)accurateVerifyIDCardNumber{
    NSString *value = [self stripInPlace];
    int length = 0;
    if (value) {
        length = (int)value.length;
        if (length != 15 && length != 18) {
            return NO;
        }
    }else {
        return NO;
    }
    // 省份代码
    NSArray *areasArray = @[
                           @"11",//北京市|110000，
                           @"12",//天津市|120000，
                           @"13",//河北省|130000，
                           @"14",//山西省|140000，
                           @"15",//内蒙古自治区|150000，
                           @"21",//辽宁省|210000，
                           @"22",//吉林省|220000，
                           @"23",//黑龙江省|230000，
                           @"31",//上海市|310000，
                           @"32",//江苏省|320000，
                           @"33",//浙江省|330000，
                           @"34",//安徽省|340000，
                           @"35",//福建省|350000，
                           @"36",//江西省|360000，
                           @"37",//山东省|370000，
                           @"41",//河南省|410000，
                           @"42",//湖北省|420000，
                           @"43",//湖南省|430000，
                           @"44",//广东省|440000，
                           @"45",//广西壮族自治区|450000，
                           @"46",//海南省|460000，
                           @"50",//重庆市|500000，
                           @"51",//四川省|510000，
                           @"52",//贵州省|520000，
                           @"53",//云南省|530000，
                           @"54",//西藏自治区|540000，
                           @"61",//陕西省|610000，
                           @"62",//甘肃省|620000，
                           @"63",//青海省|630000，
                           @"64",//宁夏回族自治区|640000，
                           @"65",//新疆维吾尔自治区|650000，
                           @"71",//台湾省（886)|710000,
                           @"81",//香港特别行政区（852)|810000，
                           @"82",//澳门特别行政区（853)|820000
                           @"91"
                           ];
    
    NSString *valueStart2 = [value substringToIndex:2];
    if ([areasArray indexOfObject:valueStart2] == NSNotFound) {
        return NO;
    }
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year = 0;
    switch (length) {
        case 15:
        {
            year = [value substringWithRange:NSMakeRange(6,2)].intValue + 1900;
            if (year % 4 == 0 || (year % 100 == 0 && year % 4 == 0)) {
                //测试出生日期的合法性
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];
            }else {
                //测试出生日期的合法性
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];
            if(numberofMatch > 0) {
                return YES;
            }else {
                return NO;
            }
        }
        case 18:
        {
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year % 4 == 0 || (year % 100 == 0 && year % 4 == 0)) {
                //测试出生日期的合法性
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];
            }else {
                //测试出生日期的合法性
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];
            if(numberofMatch > 0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue +
                         [value substringWithRange:NSMakeRange(10,1)].intValue) * 7 +
                ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) * 9  +
                ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) * 10 +
                ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) * 5  +
                ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) * 8  +
                ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) * 4  +
                ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) * 2  +
                [value substringWithRange:NSMakeRange(7,1)].intValue * 1 +
                [value substringWithRange:NSMakeRange(8,1)].intValue * 6 +
                [value substringWithRange:NSMakeRange(9,1)].intValue * 3;
                int Y = S % 11;
                NSString *M = @"F";
                NSString *JYM = @"10X98765432";
                // 判断校验位
                M = [JYM substringWithRange:NSMakeRange(Y,1)];
                // 检测ID的校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;
                }else {
                    return NO;
                }
            }else {
                return NO;
            }
        }
        default:
            return NO;
    }
}

- (BOOL)isVaildRealName{
    NSString *realName = [self stripInPlace];
    BOOL result = NO;
    if ([realName length] < 2) {
        result = NO;
    }else{
        NSString *whereString;
        NSRange range1 = [realName rangeOfString:@"·"];
        NSRange range2 = [realName rangeOfString:@"•"];
        // 中文 ·或英文 •
        if(range1.location != NSNotFound ||
           range2.location != NSNotFound ){
            //一般中间带 `•`的名字长度不会超过15位，如果有那就设高一点
            if ([realName length] > 15){
                result = NO;
            }
            whereString = @"^[\u4e00-\u9fa5]+[·•][\u4e00-\u9fa5]+$";
        }else{
            //一般正常的名字长度不会少于2位并且不超过8位，如果有那就设高一点
            if ([realName length] > 8) {
                result = NO;
            }
            whereString = @"^[\u4e00-\u9fa5]+$";
        }
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:whereString options:0 error:NULL];
        NSTextCheckingResult *match = [regex firstMatchInString:realName options:0 range:NSMakeRange(0, [realName length])];
        result = [match numberOfRanges] == 1;
    }
    return result;
}

//车牌
- (BOOL)isCarNumber{
    //车牌号:湘K-DE829 香港车牌号码:粤Z-J499港
    //其中\u4e00-\u9fa5表示unicode编码中汉字已编码部分，\u9fa5-\u9fff是保留部分，将来可能会添加
//                           ^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$
    NSString *carRegex = @"^[\u4e00-\u9fff]{1}[a-zA-Z]{1}[-][a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fff]$";
    return [self isValidateByRegex:carRegex];
}

- (BOOL)ba_regularIsValidateCarType{
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    return [self isValidateByRegex:CarTypeRegex];
}

/** 银行卡号有效性问题Luhn算法
 *  现行 16 位银联卡现行卡号开头 6 位是 622126～622925 之间的，7 到 15 位是银行自定义的，
 *  可能是发卡分行，发卡网点，发卡序号，第 16 位是校验码。
 *  16 位卡号校验位采用 Luhm 校验方法计算：
 *  1，将未带校验位的 15 位卡号从右依次编号 1 到 15，位于奇数位号上的数字乘以 2
 *  2，将奇位乘积的个十位全部相加，再加上所有偶数位上的数字
 *  3，将加法和加上校验位能被 10 整除。
 */
- (BOOL)bankCardluhmCheck{
    //取出最后一位
    NSString *lastNum = [[self substringFromIndex:(self.length - 1)] copy];
    //前15或18位
    NSString *forwardNum = [[self substringToIndex:(self.length - 1)] copy];
    NSMutableArray *forwardArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < forwardNum.length; i++) {
        NSString *subStr = [forwardNum substringWithRange:NSMakeRange(i, 1)];
        [forwardArr addObject:subStr];
    }
    
    NSMutableArray * forwardDescArr = [[NSMutableArray alloc] initWithCapacity:0];
    //前15位或者前18位倒序存进数组
    for (int i = (int)(forwardArr.count - 1); i > -1; i--) {
        [forwardDescArr addObject:forwardArr[i]];
    }
    //奇数位*2的积 < 9
    NSMutableArray *arrOddNum = [[NSMutableArray alloc] initWithCapacity:0];
    //奇数位*2的积 > 9
    NSMutableArray *arrOddNum2 = [[NSMutableArray alloc] initWithCapacity:0];
    //偶数位数组
    NSMutableArray *arrEvenNum = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i = 0; i < forwardDescArr.count; i++) {
        NSInteger num = [forwardDescArr[i] intValue];
        if (i % 2) {//偶数位
            [arrEvenNum addObject:[NSNumber numberWithInteger:num]];
        }else{//奇数位
            if (num * 2 < 9) {
                [arrOddNum addObject:[NSNumber numberWithInteger:num * 2]];
            }else{
                NSInteger decadeNum = (num * 2) / 10;
                NSInteger unitNum = (num * 2) % 10;
                [arrOddNum2 addObject:[NSNumber numberWithInteger:unitNum]];
                [arrOddNum2 addObject:[NSNumber numberWithInteger:decadeNum]];
            }
        }
    }
    
    __block  NSInteger sumOddNumTotal = 0;
    [arrOddNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNumTotal += [obj integerValue];
    }];
    
    __block NSInteger sumOddNum2Total = 0;
    [arrOddNum2 enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNum2Total += [obj integerValue];
    }];
    
    __block NSInteger sumEvenNumTotal =0 ;
    [arrEvenNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumEvenNumTotal += [obj integerValue];
    }];
    
    NSInteger lastNumber = [lastNum integerValue];
    NSInteger luhmTotal = lastNumber + sumEvenNumTotal + sumOddNum2Total + sumOddNumTotal;
    return (luhmTotal % 10 == 0) ? YES : NO;
}

- (BOOL)ba_regularIsIPAddress{
    NSString *pattern = @"((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    return results.count > 0;
}

- (BOOL)isIPAddress{
    NSString *regex = @"^(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})$";
    if ([self isValidateByRegex:regex]) {
        NSArray *componds = [self componentsSeparatedByString:@","];
        BOOL v = YES;
        for (NSString *s in componds) {
            if (s.integerValue > 255) {
                v = NO;
                break;
            }
        }
        return v;
    }
    return NO;
}

- (BOOL)isValidatIP {
    if (self.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result = [self substringWithRange:resultRange];
            //输出结果
            NSLog(@"%@",result);
            return YES;
        }
    }
    return NO;
}

- (BOOL)isMacAddress{
    NSString *macAddRegex = @"([A-Fa-f\\d]{2}:){5}[A-Fa-f\\d]{2}";
    return  [self isValidateByRegex:macAddRegex];
}

- (BOOL)isValidUrl{
    //方法1
//    // url链接的规则
//    NSString *urlPattern = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
//    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:urlPattern options:0 error:nil];
//    NSArray *results = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
//
//    // 遍历结果
//    for (NSTextCheckingResult *result in results) {
//        NSLog(@"%@ %@", NSStringFromRange(result.range), [self substringWithRange:result.range]);
//        return YES ;
//    }
//    return NO;
    
    //方法2
    NSString *regex = @"^((http)|(https))+:[^\\s]+\\.[^\\s]*$";
    return [self isValidateByRegex:regex];
}

- (BOOL)isValidChinese{
    NSString *chineseRegex = @"^[\u4e00-\u9fa5]+$";
    return [self isValidateByRegex:chineseRegex];
}

-(BOOL)isContainSChinese{
    NSString *regex = @"([\u4e00-\u9fa5]+)[\\s\\S]*$";
    return [self isValidateByRegex:regex];
}

- (BOOL)ba_regularIsEnglishAlphabet{
    NSString *englishPattern = @"^[A-Za-z]+$";
    return [self isValidateByRegex:englishPattern];
}

- (BOOL)isPureInt {
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isPureFloat {
    NSScanner *scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

#pragma mark 判断不包含特殊符号
- (BOOL)isNumAndword {
    NSString *reges = @"^[A-Za-z0-9-.]+$";
    return [self isValidateByRegex:reges];
}

- (NSString *)removeSpecialCharacter {
    NSRange urgentRange = [self rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @",.？、 ~￥#&<>《》()[]{}【】^@/￡¤|§¨「」『』￠￢￣~@#&*（）——+|《》$_€"]];
    if (urgentRange.location != NSNotFound){
        NSString *temp = [self stringByReplacingCharactersInRange:urgentRange withString:@""];
        return [temp removeSpecialCharacter];
    }
    return self;
}

+ (NSArray *)pathComponents:(NSString *)filePath{
    return [filePath pathComponents];
}

- (BOOL)isValidPostalcode {
    NSString *postalRegex = @"^[0-8]\\d{5}(?!\\d)$";
    return [self isValidateByRegex:postalRegex];
}

- (BOOL)isValidTaxNo{
    NSString *taxNoRegex = @"[0-9]\\d{13}([0-9]|X)$";
    return [self isValidateByRegex:taxNoRegex];
}

- (BOOL)isValidateByRegex:(NSString *)regex{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}

- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
              containDigtal:(BOOL)containDigtal
              containLetter:(BOOL)containLetter
      containOtherCharacter:(NSString *)containOtherCharacter
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal{
    NSString *hanzi = containChinese ? @"\u4e00-\u9fa5" : @"";
    NSString *first = firstCannotBeDigtal ? @"^[a-zA-Z_]" : @"";
    NSString *lengthRegex = [NSString stringWithFormat:@"(?=^.{%@,%@}$)", @(minLenth), @(maxLenth)];
    NSString *digtalRegex = containDigtal ? @"(?=(.*\\d.*){1})" : @"";
    NSString *letterRegex = containLetter ? @"(?=(.*[a-zA-Z].*){1})" : @"";
    NSString *characterRegex = [NSString stringWithFormat:@"(?:%@[%@A-Za-z0-9%@]+)", first, hanzi, containOtherCharacter ? containOtherCharacter : @""];
    NSString *regex = [NSString stringWithFormat:@"%@%@%@%@", lengthRegex, digtalRegex, letterRegex, characterRegex];
    return [self isValidateByRegex:regex];
}

- (PasswordStrengthLevel)passwordCheckStrength{
    NSInteger length = [self length];
    int lowercase = [self countLowercaseLetters];
    int uppercase = [self countUppercaseLetters];
    int numbers = [self countNumbers];
    int symbols = [self countSymbols];
    
    int score = 0;
    
    if(length < 5){
        score += 5;
    }else if(length > 4 && length < 8){
        score += 10;
    }else if(length > 7){
        score += 20;
    }
    
    if(numbers == 1){
        score += 10;
    }else if(numbers == 2){
        score += 15;
    }else if(numbers > 2){
        score += 20;
    }
    
    if(symbols == 1){
        score += 10;
    }else if(symbols == 2){
        score += 15;
    }else if(symbols > 2){
        score += 20;
    }
    
    if(lowercase == 1){
        score += 10;
    }else if(lowercase == 2){
        score += 15;
    }else if(lowercase > 2){
        score += 20;
    }
    
    if(uppercase == 1){
        score += 10;
    }else if(uppercase == 2){
        score += 15;
    }else if(uppercase > 2){
        score += 20;
    }
    
    if(score == 100){
        return PasswordStrengthLevelVerySecure;
    }else if (score >= 90){
        return PasswordStrengthLevelSecure;
    }else if (score >= 80){
        return PasswordStrengthLevelVeryStrong;
    }else if (score >= 70){
        return PasswordStrengthLevelStrong;
    }else if (score >= 60){
        return PasswordStrengthLevelAverage;
    }else if (score >= 50){
        return PasswordStrengthLevelWeak;
    }else{
        return PasswordStrengthLevelVeryWeak;
    }
}

/* 小写字母字符数量 */
- (int)countLowercaseLetters{
    int count = 0;
    for (int i = 0; i < [self length]; i++){
        BOOL isLowercase = [[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:[self characterAtIndex:i]];
        if(isLowercase){
            count++;
        }
    }
    return count;
}

/* 大写字母字符数量 */
- (int)countUppercaseLetters{
    int count = 0;
    for (int i = 0; i < [self length]; i++){
        BOOL isUppercase = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[self characterAtIndex:i]];
        if(isUppercase){
            count++;
        }
    }
    return count;
}

/* 数字字符数量 */
- (int)countNumbers{
    int count = 0;
    for (int i = 0; i < [self length]; i++){
        BOOL isNumber = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] characterIsMember:[self characterAtIndex:i]];
        if(isNumber){
            count++;
        }
    }
    return count;
}

- (BOOL)ba_regularIsPassword{
    NSString *passWordRegex = @"^[a-zA-Z]\\w.{5,17}$";
    return [self isValidateByRegex:passWordRegex];
}

/* 符号字符数量 */
- (int)countSymbols{
    int count = 0;
    for (int i = 0; i < [self length]; i++){
        BOOL isSymbol = [[NSCharacterSet characterSetWithCharactersInString:@"`~!?@#$€£¥§%^&*()_+-={}[]:\";<>'•\\|/"] characterIsMember:[self characterAtIndex:i]];
        if(isSymbol){
            count++;
        }
    }
    return count;
}

+ (NSString *)stringFromUnicode:(NSString *)unicode prefix:(NSString *)prefix{
    if (!unicode) {
        return @"";
    }
    
    NSString *strPrefix = (!prefix ? @"\\U" : prefix);
    NSString *unicode_temp = [unicode uppercaseString];
    if ([unicode_temp hasPrefix:strPrefix]) {
        unicode_temp = [unicode_temp substringFromIndex:2];
    }
    
    NSArray *unicodes = [[unicode_temp uppercaseString] componentsSeparatedByString:strPrefix];
    NSUInteger length = sizeof(unichar) * [unicodes count];
    unichar * pUnicodes = malloc(length);
    for (int cIdx = 0; cIdx < [unicodes count]; cIdx++) {
        NSString *cStr = [unicodes objectAtIndex:cIdx];
        unichar intRst = (unichar)[[self class] hex16StringToULongLong:cStr];
        pUnicodes[cIdx] = intRst;
    }
    NSString *source = [NSString stringWithCharacters:pUnicodes length:[unicodes count]];
    free(pUnicodes);
    return source;
}

+ (NSString *)unicodeFromString:(NSString *)string
                         prefix:(NSString *)prefix
                          align:(BOOL)align{
    NSMutableString *unicodeString = [[NSMutableString alloc] init];
    NSString *strPrefix = (!prefix ? @"\\U" : prefix);
    for (int cIdx = 0; cIdx < [string length]; cIdx++) {
        unichar strChar = [string characterAtIndex:cIdx];
        if (align) {
            [unicodeString appendFormat:@"%@%04x",strPrefix, strChar];
        } else {
            [unicodeString appendFormat:@"%@%0x",strPrefix, strChar];
        }
    }
    return unicodeString;
}

+ (NSString *)className:(NSString *)clsName
                 prefix:(NSString *)prefix
                 suffix:(NSString *)suffix{
    if (!clsName) {
        return nil;
    }
    NSString *result = clsName;
    if (prefix && [result hasPrefix:prefix]) {
        result = [result substringFromIndex:[prefix length]];
    }
    if (suffix && [result hasSuffix:suffix]) {
        result = [result substringToIndex:[result length] - [suffix length]];
    }
    return result;
}

+ (unsigned long long)hex16StringToULongLong:(NSString *)hex16String{
    NSUInteger result = 0;
    NSInteger bitIdx = 0;
    for (NSInteger cIdx = [hex16String length] - 1; cIdx >= 0; cIdx--) {
        unichar cPos = [hex16String characterAtIndex:cIdx];
        char cHexValue = 0;
        if (cPos >= '0' && cPos <='9') {
            cHexValue = cPos - '0';
        } else if (cPos >= 'A' && cPos <='F') {
            cHexValue = cPos - 'A' + 10;
        } else if (cPos >= 'a' && cPos <= 'f') {
            cHexValue = cPos - 'a' + 10;
        } else {
            break;
        }
        result += (cHexValue * pow(16, bitIdx));
        bitIdx++;
    }
    return result;
}

+ (unsigned long long)strToLong:(NSString *)string hex:(NSInteger)hex{
    return (unsigned long long)strtoll([string UTF8String], NULL, (int)hex);
}

- (NSUInteger)lineCount{
    if (self.length <= 0){
        return 0;
    }
    
    NSUInteger numberOfLines;
    NSUInteger index;
    NSUInteger stringLength = [self length];
    for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++) {
        index = NSMaxRange([self lineRangeForRange:NSMakeRange(index, 0)]);
    }
    
    if ([self isNewlineCharacterAtEnd]) {
        return numberOfLines + 1;
    }
    
    return numberOfLines;
}

- (BOOL)isNewlineCharacterAtEnd{
    if (self.length <= 0) {
        return NO;
    }
    //检查最后是否有一个换行符
    NSCharacterSet *separator = [NSCharacterSet newlineCharacterSet];
    NSRange lastRange = [self rangeOfCharacterFromSet:separator options:NSBackwardsSearch];
    return (NSMaxRange(lastRange) == self.length);
}

- (NSString *)subStringToLineIndex:(NSUInteger)lineIndex{
    NSUInteger index = [self lengthToLineIndex:lineIndex];
    return [self substringToIndex:index];
}

- (NSUInteger)lengthToLineIndex:(NSUInteger)lineIndex{
    if (self.length <= 0) {
        return 0;
    }
    
    NSUInteger numberOfLines, index, stringLength = [self length];
    for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++) {
        NSRange lineRange = [self lineRangeForRange:NSMakeRange(index, 0)];
        index = NSMaxRange(lineRange);
        if (numberOfLines == lineIndex) {
            NSString *lineString = [self substringWithRange:lineRange];
            if (![lineString isNewlineCharacterAtEnd]) {
                return index;
            }
            //把这行对应的换行符给忽略
            if (NSMaxRange([lineString rangeOfString:@"\r\n"]) == lineString.length) {
                return index - 2;
            }
            return index - 1;
        }
    }
    return 0;
}

- (BOOL)isContainChinese{
    NSUInteger length = [self length];
    for(NSInteger i = 0; i < length; i++){
        int a = [self characterAtIndex:i];
        if (a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

- (NSMutableArray *)findAtRange{
    return [self regularExpression:@"@[-_a-zA-Z0-9\u4E00-\u9FA5]+"];
}

- (NSMutableArray *)findTopicRange{
    return [self regularExpression:@"#[^@#]+?#"];
}

- (NSMutableArray *)findURLRange{
    return [self regularExpression:@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"];
}

- (NSMutableArray *)findEmailRange{
    return [self regularExpression:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}

- (NSMutableArray *)findPhoneRange{
    return [self regularExpression:@"^[1-9][0-9]{4,11}$"];
}

- (NSMutableArray *)regularExpression:(NSString *)regexString{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:kNilOptions error:NULL];
    NSMutableArray *array = [NSMutableArray array];
    NSArray *resultArray = [regex matchesInString:self options:kNilOptions range:NSMakeRange(0, self.length)];
    for (NSTextCheckingResult *result in resultArray) {
        if (!(result.range.location == NSNotFound && result.range.length <= 1)){
            [array addObject:result];
        }
    }
    return array;
}

- (NSString *)changeFormatwithMoneyAmount{
    if (self.length < 3){
        return self;
    }
    NSArray *array = [self componentsSeparatedByString:@"."];
    NSString *numInt = [array objectAtIndex:0];
    if (numInt.length <= 3){
        return self;
    }
    NSString *suffixStr = @"";
    if (array.count > 1){
        suffixStr = [NSString stringWithFormat:@".%@",[array objectAtIndex:1]];
    }
    NSMutableArray *numArr = [[NSMutableArray alloc] init];
    while (numInt.length > 3){
        NSString *temp = [numInt substringFromIndex:numInt.length - 3];
        numInt = [numInt substringToIndex:numInt.length - 3];
        [numArr addObject:[NSString stringWithFormat:@",%@",temp]];//得到的倒序的数据
    }
    for (int i = 0; i < numArr.count; i++){
        numInt = [numInt stringByAppendingFormat:@"%@",[numArr objectAtIndex:(numArr.count - 1 - i)]];
    }
    return [NSString stringWithFormat:@"%@%@",numInt,suffixStr];
}

- (NSMutableArray *)decorate{
    NSMutableArray *array = [NSMutableArray array];
    NSRegularExpression *regex = [[NSRegularExpression alloc]
                                  initWithPattern:@"\\[[^\\[\\]]*\\]"
                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                  error:nil];
    NSArray *chunks = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    NSMutableArray *matchRanges = [NSMutableArray array];
    
    for (NSTextCheckingResult *result in chunks) {
        NSString *resultStr = [self substringWithRange:[result range]];
        if ([resultStr hasPrefix:@"["] && [resultStr hasSuffix:@"]"]) {
            NSString *name = [resultStr substringWithRange:NSMakeRange(1, [resultStr length]-2)];
            name = [NSString stringWithFormat:@"[%@]",name];
            NSLog(@"name:%@",name);
            NSDictionary *faceMap = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"];
            if ([[faceMap allValues] containsObject:name]) {
                [matchRanges addObject:[NSValue valueWithRange:result.range]];
            }
        }
    }
    
    NSRange r = NSMakeRange([self length], 0);
    [matchRanges addObject:[NSValue valueWithRange:r]];
    
    NSUInteger lastLoc = 0;
    for (NSValue *v in matchRanges) {
        NSRange resultRange = [v rangeValue];
        if (resultRange.location==0) {
            NSString *faceString = [self substringWithRange:resultRange];
            NSLog(@"aaaaaaaaa:faceString:%@",faceString);
            if (faceString.length!=0) {
                [array addObject:faceString];
            }
            NSRange normalStringRange = NSMakeRange(lastLoc, resultRange.location - lastLoc);
            NSString *normalString = [self substringWithRange:normalStringRange];
            lastLoc = resultRange.location + resultRange.length;
            NSLog(@"aaaaaaa:normalString:%@",normalString);
            if (normalString.length!=0) {
                [array addObject:normalString];
            }
        }else{
            NSRange normalStringRange = NSMakeRange(lastLoc, resultRange.location - lastLoc);
            NSString *normalString = [self substringWithRange:normalStringRange];
            lastLoc = resultRange.location + resultRange.length;
            NSLog(@"bbbbbbb:normalString:%@",normalString);
            if (normalString.length!=0) {
                [array addObject:normalString];
            }
            NSString *faceString = [self substringWithRange:resultRange];
            NSLog(@"bbbbbbbb:faceString:%@",faceString);
            if (faceString.length!=0) {
                [array addObject:faceString];
            }
        }
    }
    if ([matchRanges count] == 0 && self.length != 0) {
        [array addObject:self];
    }
    NSLog(@"array:%@",array);
    return array;
}

- (NSArray *)getParamsWithUrlString:(NSString *)urlString {
    if(urlString.length == 0) {
        NSLog(@"链接为空！");
        return @[@"",@{}];
    }
    //先截取问号
    NSArray *allElements = [urlString componentsSeparatedByString:@"?"];
    //待set的参数字典
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(allElements.count == 2) {
        //有参数或者?后面为空
        NSString *myUrlString = allElements[0];
        NSString *paramsString = allElements[1];
        //获取参数对
        NSArray *paramsArray = [paramsString componentsSeparatedByString:@"&"];
        if(paramsArray.count >= 2) {
            for(NSInteger i = 0; i < paramsArray.count; i++) {
                NSString *singleParamString = paramsArray[i];
                NSArray *singleParamSet = [singleParamString componentsSeparatedByString:@"="];
                if(singleParamSet.count == 2) {
                    NSString *key = singleParamSet[0];
                    NSString *value = singleParamSet[1];
                    if(key.length > 0 || value.length > 0) {
                        [params setObject:value.length > 0 ? value : @"" forKey:key.length > 0 ? key : @""];
                    }
                }
            }
        }else if(paramsArray.count == 1) {
            //无 &。url只有?后一个参数
            NSString *singleParamString = paramsArray[0];
            NSArray *singleParamSet = [singleParamString componentsSeparatedByString:@"="];
            if(singleParamSet.count == 2) {
                NSString *key = singleParamSet[0];
                NSString *value = singleParamSet[1];
                if(key.length > 0 || value.length > 0) {
                    [params setObject:value.length > 0 ? value : @"" forKey:key.length > 0 ? key : @""];
                }
            }else{
                //问号后面啥也没有 xxxx?  无需处理
            }
        }
        //整合url及参数
        return @[myUrlString,params];
    }else if(allElements.count > 2) {
        NSLog(@"链接不合法！链接包含多个\"?\"");
        return @[@"",@{}];
    }else{
        NSLog(@"链接不包含参数！");
        return @[urlString,@{}];
    }
}

- (NSDictionary *)parameterWithUrlString:(NSString *)urlString {
    urlString = [urlString stringByRemovingPercentEncoding];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    NSURL *tempUrl = [NSURL URLWithString:urlString];
     //传入url创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:tempUrl.absoluteString];
    //回调遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [parm setObject:obj.value forKey:obj.name];
    }];
    return parm;
}

- (NSDictionary *)dictionaryWithUrlString:(NSString *)urlString{
    if (urlString && urlString.length && [urlString rangeOfString:@"?"].length == 1) {
        NSArray *array = [urlString componentsSeparatedByString:@"?"];
        if (array && array.count == 2) {
            NSString *paramsStr = array[1];
            if (paramsStr.length) {
                NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
                NSArray *paramArray = [paramsStr componentsSeparatedByString:@"&"];
                for (NSString *param in paramArray) {
                    if (param && param.length) {
                        NSArray *parArr = [param componentsSeparatedByString:@"="];
                        if (parArr.count == 2) {
                            [paramsDict setObject:parArr[1] forKey:parArr[0]];
                        }
                    }
                }
                return paramsDict;
            }else{
                return nil;
            }
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

+ (NSString *)randomKeyWithkeyLength:(NSUInteger)length{
    return [self randomKeyWithAlphabet:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                             keyLength:length];
}

+ (NSString *)randomKeyWithAlphabet:(NSString *)alphabet
                          keyLength:(NSUInteger)length{
    //1.UUIDString
    NSString *string = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    //2.时间戳
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%.0f",time];
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: length];
    for (int i = 0; i < length; i++) {
        [randomString appendFormat: @"%C", [alphabet characterAtIndex:arc4random_uniform((u_int32_t)[alphabet length])]];
    }
    
    //==> UUIDString去掉最后一项,再拼接上"时间戳"-"随机字符串kRandomLength位"
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[string componentsSeparatedByString:@"-"]];
    [array removeLastObject];
    [array addObject:timeStr];
    [array addObject:randomString];
    return [array componentsJoinedByString:@"-"];
}

- (CGSize)boundingRectWithSize:(CGSize)size
                          font:(UIFont *)font{
    return [self boundingRectWithSize:size
                                 font:font
                          lineSpacing:0.0];
}

- (CGSize)boundingRectWithSize:(CGSize)size
                          font:(UIFont *)font
                   lineSpacing:(CGFloat)lineSpacing{
    return [self boundingRectWithSize:size
                                 font:font
                          lineSpacing:lineSpacing
                          wordSpacing:0.0];
}

- (CGFloat)boundingRectWithSize:(CGSize)size
                           font:(UIFont *)font
                    lineSpacing:(CGFloat)lineSpacing
                       maxLines:(NSInteger)maxLines{
    if(maxLines <= 0) {
        return 0;
    }
    CGFloat maxHeight = font.lineHeight * maxLines + lineSpacing * (maxLines - 1);
    CGSize orginalSize = [self boundingRectWithSize:size
                                               font:font
                                        lineSpacing:lineSpacing
                                        wordSpacing:0.0];
    if(orginalSize.height >= maxHeight) {
        return maxHeight;
    }else{
        return orginalSize.height;
    }
}

- (BOOL)isMoreThanOneLineWithSize:(CGSize)size
                             font:(UIFont *)font
                     lineSpaceing:(CGFloat)lineSpacing{
    if([self boundingRectWithSize:size
                             font:font
                      lineSpacing:lineSpacing
                      wordSpacing:0.0].height > font.lineHeight){
        return YES;
    }else{
        return NO;
    }
}

- (CGSize)boundingRectWithSize:(CGSize)size
                          font:(UIFont *)font
                   lineSpacing:(CGFloat)lineSpacing
                   wordSpacing:(CGFloat)wordSpacing{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    //行间距（垂直上的间距）
    paraStyle.lineSpacing = lineSpacing;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0,self.length)];
    //设置字间距
    [attributeString addAttribute:NSKernAttributeName value:@(wordSpacing) range:NSMakeRange(0,self.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,self.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributeString boundingRectWithSize:size
                                                options:options
                                                context:nil];
    //    NSLog(@"size:%@", NSStringFromCGSize(rect.size));
    //文本的高度减去字体高度小于等于行间距，判断为当前只有1行
    if((rect.size.height - font.lineHeight) <= paraStyle.lineSpacing) {
        //如果包含中文
        if([self isContainChinese]) {
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height - paraStyle.lineSpacing);
        }
    }
    return rect.size;
}

- (NSArray *)getLinesArrayWihtFont:(UIFont *)font
                          maxWidth:(CGFloat)width{
    CTFontRef myFont = CTFontCreateWithName(( CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge  id)myFont range:NSMakeRange(0, attStr.length)];
    CFRelease(myFont);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,width,INT_MAX));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = (NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc] init];
    for (id line in lines) {
        CTLineRef lineRef = (__bridge  CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [self substringWithRange:range];
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithFloat:0.0]));
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithInt:0.0]));
        //NSLog(@"''''''''''''''''''%@",lineString);
        [linesArray addObject:lineString];
    }
    CGPathRelease(path);
    CFRelease(frame);
    CFRelease(frameSetter);
    return (NSArray *)linesArray;
}

@end
