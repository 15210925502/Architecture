//
//  NSString+RegexCategory.m
//  testDemo
//
//  Created by ๅ็ฑ on 2016/11/7.
//  Copyright ยฉ 2016ๅนด DS-Team. All rights reserved.
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
                                 @"๐": @":smile:",
                                 @"๐": @[@":laughing:", @":D"],
                                 @"๐": @":blush:",
                                 @"๐": @[@":smiley:", @":)", @":-)"],
                                 @"โบ": @":relaxed:",
                                 @"๐": @":smirk:",
                                 @"๐": @[@":disappointed:", @":("],
                                 @"๐": @":heart_eyes:",
                                 @"๐": @":kissing_heart:",
                                 @"๐": @":kissing_closed_eyes:",
                                 @"๐ณ": @":flushed:",
                                 @"๐ฅ": @":relieved:",
                                 @"๐": @":satisfied:",
                                 @"๐": @":grin:",
                                 @"๐": @[@":wink:", @";)", @";-)"],
                                 @"๐": @[@":wink2:", @":P"],
                                 @"๐": @":stuck_out_tongue_closed_eyes:",
                                 @"๐": @":grinning:",
                                 @"๐": @":kissing:",
                                 @"๐": @":kissing_smiling_eyes:",
                                 @"๐": @":stuck_out_tongue:",
                                 @"๐ด": @":sleeping:",
                                 @"๐": @":worried:",
                                 @"๐ฆ": @":frowning:",
                                 @"๐ง": @":anguished:",
                                 @"๐ฎ": @[@":open_mouth:", @":o"],
                                 @"๐ฌ": @":grimacing:",
                                 @"๐": @":confused:",
                                 @"๐ฏ": @":hushed:",
                                 @"๐": @":expressionless:",
                                 @"๐": @":unamused:",
                                 @"๐": @":sweat_smile:",
                                 @"๐": @":sweat:",
                                 @"๐ฉ": @":weary:",
                                 @"๐": @":pensive:",
                                 @"๐": @":dissapointed:",
                                 @"๐": @":confounded:",
                                 @"๐จ": @":fearful:",
                                 @"๐ฐ": @":cold_sweat:",
                                 @"๐ฃ": @":persevere:",
                                 @"๐ข": @":cry:",
                                 @"๐ญ": @":sob:",
                                 @"๐": @":joy:",
                                 @"๐ฒ": @":astonished:",
                                 @"๐ฑ": @":scream:",
                                 @"๐ซ": @":tired_face:",
                                 @"๐?": @":angry:",
                                 @"๐ก": @":rage:",
                                 @"๐ค": @":triumph:",
                                 @"๐ช": @":sleepy:",
                                 @"๐": @":yum:",
                                 @"๐ท": @":mask:",
                                 @"๐": @":sunglasses:",
                                 @"๐ต": @":dizzy_face:",
                                 @"๐ฟ": @":imp:",
                                 @"๐": @":smiling_imp:",
                                 @"๐": @":neutral_face:",
                                 @"๐ถ": @":no_mouth:",
                                 @"๐": @":innocent:",
                                 @"๐ฝ": @":alien:",
                                 @"๐": @":yellow_heart:",
                                 @"๐": @":blue_heart:",
                                 @"๐": @":purple_heart:",
                                 @"โค": @":heart:",
                                 @"๐": @":green_heart:",
                                 @"๐": @":broken_heart:",
                                 @"๐": @":heartbeat:",
                                 @"๐": @":heartpulse:",
                                 @"๐": @":two_hearts:",
                                 @"๐": @":revolving_hearts:",
                                 @"๐": @":cupid:",
                                 @"๐": @":sparkling_heart:",
                                 @"โจ": @":sparkles:",
                                 @"โญ๏ธ": @":star:",
                                 @"๐": @":star2:",
                                 @"๐ซ": @":dizzy:",
                                 @"๐ฅ": @":boom:",
                                 @"๐ข": @":anger:",
                                 @"โ": @":exclamation:",
                                 @"โ": @":question:",
                                 @"โ": @":grey_exclamation:",
                                 @"โ": @":grey_question:",
                                 @"๐ค": @":zzz:",
                                 @"๐จ": @":dash:",
                                 @"๐ฆ": @":sweat_drops:",
                                 @"๐ถ": @":notes:",
                                 @"๐ต": @":musical_note:",
                                 @"๐ฅ": @":fire:",
                                 @"๐ฉ": @[@":poop:", @":hankey:", @":shit:"],
                                 @"๐": @[@":+1:", @":thumbsup:"],
                                 @"๐": @[@":-1:", @":thumbsdown:"],
                                 @"๐": @":ok_hand:",
                                 @"๐": @":punch:",
                                 @"โ": @":fist:",
                                 @"โ": @":v:",
                                 @"๐": @":wave:",
                                 @"โ": @":hand:",
                                 @"๐": @":open_hands:",
                                 @"โ": @":point_up:",
                                 @"๐": @":point_down:",
                                 @"๐": @":point_left:",
                                 @"๐": @":point_right:",
                                 @"๐": @":raised_hands:",
                                 @"๐": @":pray:",
                                 @"๐": @":point_up_2:",
                                 @"๐": @":clap:",
                                 @"๐ช": @":muscle:",
                                 @"๐ถ": @":walking:",
                                 @"๐": @":runner:",
                                 @"๐ซ": @":couple:",
                                 @"๐ช": @":family:",
                                 @"๐ฌ": @":two_men_holding_hands:",
                                 @"๐ญ": @":two_women_holding_hands:",
                                 @"๐": @":dancer:",
                                 @"๐ฏ": @":dancers:",
                                 @"๐": @":ok_woman:",
                                 @"๐": @":no_good:",
                                 @"๐": @":information_desk_person:",
                                 @"๐": @":raised_hand:",
                                 @"๐ฐ": @":bride_with_veil:",
                                 @"๐": @":person_with_pouting_face:",
                                 @"๐": @":person_frowning:",
                                 @"๐": @":bow:",
                                 @"๐": @":couplekiss:",
                                 @"๐": @":couple_with_heart:",
                                 @"๐": @":massage:",
                                 @"๐": @":haircut:",
                                 @"๐": @":nail_care:",
                                 @"๐ฆ": @":boy:",
                                 @"๐ง": @":girl:",
                                 @"๐ฉ": @":woman:",
                                 @"๐จ": @":man:",
                                 @"๐ถ": @":baby:",
                                 @"๐ต": @":older_woman:",
                                 @"๐ด": @":older_man:",
                                 @"๐ฑ": @":person_with_blond_hair:",
                                 @"๐ฒ": @":man_with_gua_pi_mao:",
                                 @"๐ณ": @":man_with_turban:",
                                 @"๐ท": @":construction_worker:",
                                 @"๐ฎ": @":cop:",
                                 @"๐ผ": @":angel:",
                                 @"๐ธ": @":princess:",
                                 @"๐บ": @":smiley_cat:",
                                 @"๐ธ": @":smile_cat:",
                                 @"๐ป": @":heart_eyes_cat:",
                                 @"๐ฝ": @":kissing_cat:",
                                 @"๐ผ": @":smirk_cat:",
                                 @"๐": @":scream_cat:",
                                 @"๐ฟ": @":crying_cat_face:",
                                 @"๐น": @":joy_cat:",
                                 @"๐พ": @":pouting_cat:",
                                 @"๐น": @":japanese_ogre:",
                                 @"๐บ": @":japanese_goblin:",
                                 @"๐": @":see_no_evil:",
                                 @"๐": @":hear_no_evil:",
                                 @"๐": @":speak_no_evil:",
                                 @"๐": @":guardsman:",
                                 @"๐": @":skull:",
                                 @"๐ฃ": @":feet:",
                                 @"๐": @":lips:",
                                 @"๐": @":kiss:",
                                 @"๐ง": @":droplet:",
                                 @"๐": @":ear:",
                                 @"๐": @":eyes:",
                                 @"๐": @":nose:",
                                 @"๐": @":tongue:",
                                 @"๐": @":love_letter:",
                                 @"๐ค": @":bust_in_silhouette:",
                                 @"๐ฅ": @":busts_in_silhouette:",
                                 @"๐ฌ": @":speech_balloon:",
                                 @"๐ญ": @":thought_balloon:",
                                 @"โ": @":sunny:",
                                 @"โ": @":umbrella:",
                                 @"โ": @":cloud:",
                                 @"โ": @":snowflake:",
                                 @"โ": @":snowman:",
                                 @"โก": @":zap:",
                                 @"๐": @":cyclone:",
                                 @"๐": @":foggy:",
                                 @"๐": @":ocean:",
                                 @"๐ฑ": @":cat:",
                                 @"๐ถ": @":dog:",
                                 @"๐ญ": @":mouse:",
                                 @"๐น": @":hamster:",
                                 @"๐ฐ": @":rabbit:",
                                 @"๐บ": @":wolf:",
                                 @"๐ธ": @":frog:",
                                 @"๐ฏ": @":tiger:",
                                 @"๐จ": @":koala:",
                                 @"๐ป": @":bear:",
                                 @"๐ท": @":pig:",
                                 @"๐ฝ": @":pig_nose:",
                                 @"๐ฎ": @":cow:",
                                 @"๐": @":boar:",
                                 @"๐ต": @":monkey_face:",
                                 @"๐": @":monkey:",
                                 @"๐ด": @":horse:",
                                 @"๐": @":racehorse:",
                                 @"๐ซ": @":camel:",
                                 @"๐": @":sheep:",
                                 @"๐": @":elephant:",
                                 @"๐ผ": @":panda_face:",
                                 @"๐": @":snake:",
                                 @"๐ฆ": @":bird:",
                                 @"๐ค": @":baby_chick:",
                                 @"๐ฅ": @":hatched_chick:",
                                 @"๐ฃ": @":hatching_chick:",
                                 @"๐": @":chicken:",
                                 @"๐ง": @":penguin:",
                                 @"๐ข": @":turtle:",
                                 @"๐": @":bug:",
                                 @"๐": @":honeybee:",
                                 @"๐": @":ant:",
                                 @"๐": @":beetle:",
                                 @"๐": @":snail:",
                                 @"๐": @":octopus:",
                                 @"๐?": @":tropical_fish:",
                                 @"๐": @":fish:",
                                 @"๐ณ": @":whale:",
                                 @"๐": @":whale2:",
                                 @"๐ฌ": @":dolphin:",
                                 @"๐": @":cow2:",
                                 @"๐": @":ram:",
                                 @"๐": @":rat:",
                                 @"๐": @":water_buffalo:",
                                 @"๐": @":tiger2:",
                                 @"๐": @":rabbit2:",
                                 @"๐": @":dragon:",
                                 @"๐": @":goat:",
                                 @"๐": @":rooster:",
                                 @"๐": @":dog2:",
                                 @"๐": @":pig2:",
                                 @"๐": @":mouse2:",
                                 @"๐": @":ox:",
                                 @"๐ฒ": @":dragon_face:",
                                 @"๐ก": @":blowfish:",
                                 @"๐": @":crocodile:",
                                 @"๐ช": @":dromedary_camel:",
                                 @"๐": @":leopard:",
                                 @"๐": @":cat2:",
                                 @"๐ฉ": @":poodle:",
                                 @"๐พ": @":paw_prints:",
                                 @"๐": @":bouquet:",
                                 @"๐ธ": @":cherry_blossom:",
                                 @"๐ท": @":tulip:",
                                 @"๐": @":four_leaf_clover:",
                                 @"๐น": @":rose:",
                                 @"๐ป": @":sunflower:",
                                 @"๐บ": @":hibiscus:",
                                 @"๐": @":maple_leaf:",
                                 @"๐": @":leaves:",
                                 @"๐": @":fallen_leaf:",
                                 @"๐ฟ": @":herb:",
                                 @"๐": @":mushroom:",
                                 @"๐ต": @":cactus:",
                                 @"๐ด": @":palm_tree:",
                                 @"๐ฒ": @":evergreen_tree:",
                                 @"๐ณ": @":deciduous_tree:",
                                 @"๐ฐ": @":chestnut:",
                                 @"๐ฑ": @":seedling:",
                                 @"๐ผ": @":blossum:",
                                 @"๐พ": @":ear_of_rice:",
                                 @"๐": @":shell:",
                                 @"๐": @":globe_with_meridians:",
                                 @"๐": @":sun_with_face:",
                                 @"๐": @":full_moon_with_face:",
                                 @"๐": @":new_moon_with_face:",
                                 @"๐": @":new_moon:",
                                 @"๐": @":waxing_crescent_moon:",
                                 @"๐": @":first_quarter_moon:",
                                 @"๐": @":waxing_gibbous_moon:",
                                 @"๐": @":full_moon:",
                                 @"๐": @":waning_gibbous_moon:",
                                 @"๐": @":last_quarter_moon:",
                                 @"๐": @":waning_crescent_moon:",
                                 @"๐": @":last_quarter_moon_with_face:",
                                 @"๐": @":first_quarter_moon_with_face:",
                                 @"๐": @":moon:",
                                 @"๐": @":earth_africa:",
                                 @"๐": @":earth_americas:",
                                 @"๐": @":earth_asia:",
                                 @"๐": @":volcano:",
                                 @"๐": @":milky_way:",
                                 @"โ": @":partly_sunny:",
                                 @"๐": @":bamboo:",
                                 @"๐": @":gift_heart:",
                                 @"๐": @":dolls:",
                                 @"๐": @":school_satchel:",
                                 @"๐": @":mortar_board:",
                                 @"๐": @":flags:",
                                 @"๐": @":fireworks:",
                                 @"๐": @":sparkler:",
                                 @"๐": @":wind_chime:",
                                 @"๐": @":rice_scene:",
                                 @"๐": @":jack_o_lantern:",
                                 @"๐ป": @":ghost:",
                                 @"๐": @":santa:",
                                 @"๐ฑ": @":8ball:",
                                 @"โฐ": @":alarm_clock:",
                                 @"๐": @":apple:",
                                 @"๐จ": @":art:",
                                 @"๐ผ": @":baby_bottle:",
                                 @"๐": @":balloon:",
                                 @"๐": @":banana:",
                                 @"๐": @":bar_chart:",
                                 @"โพ": @":baseball:",
                                 @"๐": @":basketball:",
                                 @"๐": @":bath:",
                                 @"๐": @":bathtub:",
                                 @"๐": @":battery:",
                                 @"๐บ": @":beer:",
                                 @"๐ป": @":beers:",
                                 @"๐": @":bell:",
                                 @"๐ฑ": @":bento:",
                                 @"๐ด": @":bicyclist:",
                                 @"๐": @":bikini:",
                                 @"๐": @":birthday:",
                                 @"๐": @":black_joker:",
                                 @"โ": @":black_nib:",
                                 @"๐": @":blue_book:",
                                 @"๐ฃ": @":bomb:",
                                 @"๐": @":bookmark:",
                                 @"๐": @":bookmark_tabs:",
                                 @"๐": @":books:",
                                 @"๐ข": @":boot:",
                                 @"๐ณ": @":bowling:",
                                 @"๐": @":bread:",
                                 @"๐ผ": @":briefcase:",
                                 @"๐ก": @":bulb:",
                                 @"๐ฐ": @":cake:",
                                 @"๐": @":calendar:",
                                 @"๐ฒ": @":calling:",
                                 @"๐ท": @":camera:",
                                 @"๐ฌ": @":candy:",
                                 @"๐": @":card_index:",
                                 @"๐ฟ": @":cd:",
                                 @"๐": @":chart_with_downwards_trend:",
                                 @"๐": @":chart_with_upwards_trend:",
                                 @"๐": @":cherries:",
                                 @"๐ซ": @":chocolate_bar:",
                                 @"๐": @":christmas_tree:",
                                 @"๐ฌ": @":clapper:",
                                 @"๐": @":clipboard:",
                                 @"๐": @":closed_book:",
                                 @"๐": @":closed_lock_with_key:",
                                 @"๐": @":closed_umbrella:",
                                 @"โฃ": @":clubs:",
                                 @"๐ธ": @":cocktail:",
                                 @"โ": @":coffee:",
                                 @"๐ป": @":computer:",
                                 @"๐": @":confetti_ball:",
                                 @"๐ช": @":cookie:",
                                 @"๐ฝ": @":corn:",
                                 @"๐ณ": @":credit_card:",
                                 @"๐": @":crown:",
                                 @"๐ฎ": @":crystal_ball:",
                                 @"๐": @":curry:",
                                 @"๐ฎ": @":custard:",
                                 @"๐ก": @":dango:",
                                 @"๐ฏ": @":dart:",
                                 @"๐": @":date:",
                                 @"โฆ": @":diamonds:",
                                 @"๐ต": @":dollar:",
                                 @"๐ช": @":door:",
                                 @"๐ฉ": @":doughnut:",
                                 @"๐": @":dress:",
                                 @"๐": @":dvd:",
                                 @"๐ง": @":e-mail:",
                                 @"๐ณ": @":egg:",
                                 @"๐": @":eggplant:",
                                 @"๐": @":electric_plug:",
                                 @"โ": @":email:",
                                 @"๐ถ": @":euro:",
                                 @"๐": @":eyeglasses:",
                                 @"๐?": @":fax:",
                                 @"๐": @":file_folder:",
                                 @"๐ฅ": @":fish_cake:",
                                 @"๐ฃ": @":fishing_pole_and_fish:",
                                 @"๐ฆ": @":flashlight:",
                                 @"๐พ": @":floppy_disk:",
                                 @"๐ด": @":flower_playing_cards:",
                                 @"๐": @":football:",
                                 @"๐ด": @":fork_and_knife:",
                                 @"๐ค": @":fried_shrimp:",
                                 @"๐": @":fries:",
                                 @"๐ฒ": @":game_die:",
                                 @"๐": @":gem:",
                                 @"๐": @":gift:",
                                 @"โณ": @":golf:",
                                 @"๐": @":grapes:",
                                 @"๐": @":green_apple:",
                                 @"๐": @":green_book:",
                                 @"๐ธ": @":guitar:",
                                 @"๐ซ": @":gun:",
                                 @"๐": @":hamburger:",
                                 @"๐จ": @":hammer:",
                                 @"๐": @":handbag:",
                                 @"๐ง": @":headphones:",
                                 @"โฅ": @":hearts:",
                                 @"๐": @":high_brightness:",
                                 @"๐?": @":high_heel:",
                                 @"๐ช": @":hocho:",
                                 @"๐ฏ": @":honey_pot:",
                                 @"๐": @":horse_racing:",
                                 @"โ": @":hourglass:",
                                 @"โณ": @":hourglass_flowing_sand:",
                                 @"๐จ": @":ice_cream:",
                                 @"๐ฆ": @":icecream:",
                                 @"๐ฅ": @":inbox_tray:",
                                 @"๐จ": @":incoming_envelope:",
                                 @"๐ฑ": @":iphone:",
                                 @"๐ฎ": @":izakaya_lantern:",
                                 @"๐": @":jeans:",
                                 @"๐": @":key:",
                                 @"๐": @":kimono:",
                                 @"๐": @":ledger:",
                                 @"๐": @":lemon:",
                                 @"๐": @":lipstick:",
                                 @"๐": @":lock:",
                                 @"๐": @":lock_with_ink_pen:",
                                 @"๐ญ": @":lollipop:",
                                 @"โฟ": @":loop:",
                                 @"๐ข": @":loudspeaker:",
                                 @"๐": @":low_brightness:",
                                 @"๐": @":mag:",
                                 @"๐": @":mag_right:",
                                 @"๐": @":mahjong:",
                                 @"๐ซ": @":mailbox:",
                                 @"๐ช": @":mailbox_closed:",
                                 @"๐ฌ": @":mailbox_with_mail:",
                                 @"๐ญ": @":mailbox_with_no_mail:",
                                 @"๐": @":mans_shoe:",
                                 @"๐": @":meat_on_bone:",
                                 @"๐ฃ": @":mega:",
                                 @"๐": @":melon:",
                                 @"๐": @":memo:",
                                 @"๐ค": @":microphone:",
                                 @"๐ฌ": @":microscope:",
                                 @"๐ฝ": @":minidisc:",
                                 @"๐ธ": @":money_with_wings:",
                                 @"๐ฐ": @":moneybag:",
                                 @"๐ต": @":mountain_bicyclist:",
                                 @"๐ฅ": @":movie_camera:",
                                 @"๐น": @":musical_keyboard:",
                                 @"๐ผ": @":musical_score:",
                                 @"๐": @":mute:",
                                 @"๐": @":name_badge:",
                                 @"๐": @":necktie:",
                                 @"๐ฐ": @":newspaper:",
                                 @"๐": @":no_bell:",
                                 @"๐": @":notebook:",
                                 @"๐": @":notebook_with_decorative_cover:",
                                 @"๐ฉ": @":nut_and_bolt:",
                                 @"๐ข": @":oden:",
                                 @"๐": @":open_file_folder:",
                                 @"๐": @":orange_book:",
                                 @"๐ค": @":outbox_tray:",
                                 @"๐": @":page_facing_up:",
                                 @"๐": @":page_with_curl:",
                                 @"๐": @":pager:",
                                 @"๐": @":paperclip:",
                                 @"๐": @":peach:",
                                 @"๐": @":pear:",
                                 @"โ": @":pencil2:",
                                 @"โ": @":phone:",
                                 @"๐": @":pill:",
                                 @"๐": @":pineapple:",
                                 @"๐": @":pizza:",
                                 @"๐ฏ": @":postal_horn:",
                                 @"๐ฎ": @":postbox:",
                                 @"๐": @":pouch:",
                                 @"๐": @":poultry_leg:",
                                 @"๐ท": @":pound:",
                                 @"๐": @":purse:",
                                 @"๐": @":pushpin:",
                                 @"๐ป": @":radio:",
                                 @"๐": @":ramen:",
                                 @"๐": @":ribbon:",
                                 @"๐": @":rice:",
                                 @"๐": @":rice_ball:",
                                 @"๐": @":rice_cracker:",
                                 @"๐": @":ring:",
                                 @"๐": @":rugby_football:",
                                 @"๐ฝ": @":running_shirt_with_sash:",
                                 @"๐ถ": @":sake:",
                                 @"๐ก": @":sandal:",
                                 @"๐ก": @":satellite:",
                                 @"๐ท": @":saxophone:",
                                 @"โ": @":scissors:",
                                 @"๐": @":scroll:",
                                 @"๐บ": @":seat:",
                                 @"๐ง": @":shaved_ice:",
                                 @"๐": @":shirt:",
                                 @"๐ฟ": @":shower:",
                                 @"๐ฟ": @":ski:",
                                 @"๐ฌ": @":smoking:",
                                 @"๐": @":snowboarder:",
                                 @"โฝ": @":soccer:",
                                 @"๐": @":sound:",
                                 @"๐พ": @":space_invader:",
                                 @"โ?": @":spades:",
                                 @"๐": @":spaghetti:",
                                 @"๐": @":speaker:",
                                 @"๐ฒ": @":stew:",
                                 @"๐": @":straight_ruler:",
                                 @"๐": @":strawberry:",
                                 @"๐": @":surfer:",
                                 @"๐ฃ": @":sushi:",
                                 @"๐?": @":sweet_potato:",
                                 @"๐": @":swimmer:",
                                 @"๐": @":syringe:",
                                 @"๐": @":tada:",
                                 @"๐": @":tanabata_tree:",
                                 @"๐": @":tangerine:",
                                 @"๐ต": @":tea:",
                                 @"๐": @":telephone_receiver:",
                                 @"๐ญ": @":telescope:",
                                 @"๐พ": @":tennis:",
                                 @"๐ฝ": @":toilet:",
                                 @"๐": @":tomato:",
                                 @"๐ฉ": @":tophat:",
                                 @"๐": @":triangular_ruler:",
                                 @"๐": @":trophy:",
                                 @"๐น": @":tropical_drink:",
                                 @"๐บ": @":trumpet:",
                                 @"๐บ": @":tv:",
                                 @"๐": @":unlock:",
                                 @"๐ผ": @":vhs:",
                                 @"๐น": @":video_camera:",
                                 @"๐ฎ": @":video_game:",
                                 @"๐ป": @":violin:",
                                 @"โ": @":watch:",
                                 @"๐": @":watermelon:",
                                 @"๐ท": @":wine_glass:",
                                 @"๐": @":womans_clothes:",
                                 @"๐": @":womans_hat:",
                                 @"๐ง": @":wrench:",
                                 @"๐ด": @":yen:",
                                 @"๐ก": @":aerial_tramway:",
                                 @"โ": @":airplane:",
                                 @"๐": @":ambulance:",
                                 @"โ": @":anchor:",
                                 @"๐": @":articulated_lorry:",
                                 @"๐ง": @":atm:",
                                 @"๐ฆ": @":bank:",
                                 @"๐": @":barber:",
                                 @"๐ฐ": @":beginner:",
                                 @"๐ฒ": @":bike:",
                                 @"๐": @":blue_car:",
                                 @"โต": @":boat:",
                                 @"๐": @":bridge_at_night:",
                                 @"๐": @":bullettrain_front:",
                                 @"๐": @":bullettrain_side:",
                                 @"๐": @":bus:",
                                 @"๐": @":busstop:",
                                 @"๐": @":car:",
                                 @"๐?": @":carousel_horse:",
                                 @"๐": @":checkered_flag:",
                                 @"โช": @":church:",
                                 @"๐ช": @":circus_tent:",
                                 @"๐": @":city_sunrise:",
                                 @"๐": @":city_sunset:",
                                 @"๐ง": @":construction:",
                                 @"๐ช": @":convenience_store:",
                                 @"๐": @":crossed_flags:",
                                 @"๐ฌ": @":department_store:",
                                 @"๐ฐ": @":european_castle:",
                                 @"๐ค": @":european_post_office:",
                                 @"๐ญ": @":factory:",
                                 @"๐ก": @":ferris_wheel:",
                                 @"๐": @":fire_engine:",
                                 @"โฒ": @":fountain:",
                                 @"โฝ": @":fuelpump:",
                                 @"๐": @":helicopter:",
                                 @"๐ฅ": @":hospital:",
                                 @"๐จ": @":hotel:",
                                 @"โจ": @":hotsprings:",
                                 @"๐?": @":house:",
                                 @"๐ก": @":house_with_garden:",
                                 @"๐พ": @":japan:",
                                 @"๐ฏ": @":japanese_castle:",
                                 @"๐": @":light_rail:",
                                 @"๐ฉ": @":love_hotel:",
                                 @"๐": @":minibus:",
                                 @"๐": @":monorail:",
                                 @"๐ป": @":mount_fuji:",
                                 @"๐?": @":mountain_cableway:",
                                 @"๐": @":mountain_railway:",
                                 @"๐ฟ": @":moyai:",
                                 @"๐ข": @":office:",
                                 @"๐": @":oncoming_automobile:",
                                 @"๐": @":oncoming_bus:",
                                 @"๐": @":oncoming_police_car:",
                                 @"๐": @":oncoming_taxi:",
                                 @"๐ญ": @":performing_arts:",
                                 @"๐": @":police_car:",
                                 @"๐ฃ": @":post_office:",
                                 @"๐": @":railway_car:",
                                 @"๐": @":rainbow:",
                                 @"๐": @":rocket:",
                                 @"๐ข": @":roller_coaster:",
                                 @"๐จ": @":rotating_light:",
                                 @"๐": @":round_pushpin:",
                                 @"๐ฃ": @":rowboat:",
                                 @"๐ซ": @":school:",
                                 @"๐ข": @":ship:",
                                 @"๐ฐ": @":slot_machine:",
                                 @"๐ค": @":speedboat:",
                                 @"๐?": @":stars:",
                                 @"๐": @":city-night:",
                                 @"๐": @":station:",
                                 @"๐ฝ": @":statue_of_liberty:",
                                 @"๐": @":steam_locomotive:",
                                 @"๐": @":sunrise:",
                                 @"๐": @":sunrise_over_mountains:",
                                 @"๐": @":suspension_railway:",
                                 @"๐": @":taxi:",
                                 @"โบ": @":tent:",
                                 @"๐ซ": @":ticket:",
                                 @"๐ผ": @":tokyo_tower:",
                                 @"๐": @":tractor:",
                                 @"๐ฅ": @":traffic_light:",
                                 @"๐": @":train2:",
                                 @"๐": @":tram:",
                                 @"๐ฉ": @":triangular_flag_on_post:",
                                 @"๐": @":trolleybus:",
                                 @"๐": @":truck:",
                                 @"๐ฆ": @":vertical_traffic_light:",
                                 @"โ?": @":warning:",
                                 @"๐": @":wedding:",
                                 @"๐ฏ๐ต": @":jp:",
                                 @"๐ฐ๐ท": @":kr:",
                                 @"๐จ๐ณ": @":cn:",
                                 @"๐บ๐ธ": @":us:",
                                 @"๐ซ๐ท": @":fr:",
                                 @"๐ช๐ธ": @":es:",
                                 @"๐ฎ๐น": @":it:",
                                 @"๐ท๐บ": @":ru:",
                                 @"๐ฌ๐ง": @":gb:",
                                 @"๐ฉ๐ช": @":de:",
                                 @"๐ฏ": @":100:",
                                 @"๐ข": @":1234:",
                                 @"๐ฐ": @":a:",
                                 @"๐": @":ab:",
                                 @"๐ค": @":abc:",
                                 @"๐ก": @":abcd:",
                                 @"๐": @":accept:",
                                 @"โ": @":aquarius:",
                                 @"โ": @":aries:",
                                 @"โ": @":arrow_backward:",
                                 @"โฌ": @":arrow_double_down:",
                                 @"โซ": @":arrow_double_up:",
                                 @"โฌ": @":arrow_down:",
                                 @"๐ฝ": @":arrow_down_small:",
                                 @"โถ": @":arrow_forward:",
                                 @"โคต": @":arrow_heading_down:",
                                 @"โคด": @":arrow_heading_up:",
                                 @"โฌ": @":arrow_left:",
                                 @"โ": @":arrow_lower_left:",
                                 @"โ": @":arrow_lower_right:",
                                 @"โก": @":arrow_right:",
                                 @"โช": @":arrow_right_hook:",
                                 @"โฌ": @":arrow_up:",
                                 @"โ": @":arrow_up_down:",
                                 @"๐ผ": @":arrow_up_small:",
                                 @"โ": @":arrow_upper_left:",
                                 @"โ": @":arrow_upper_right:",
                                 @"๐": @":arrows_clockwise:",
                                 @"๐": @":arrows_counterclockwise:",
                                 @"๐ฑ": @":b:",
                                 @"๐ผ": @":baby_symbol:",
                                 @"๐": @":baggage_claim:",
                                 @"โ": @":ballot_box_with_check:",
                                 @"โผ": @":bangbang:",
                                 @"โซ": @":black_circle:",
                                 @"๐ฒ": @":black_square_button:",
                                 @"โ": @":cancer:",
                                 @"๐?": @":capital_abcd:",
                                 @"โ": @":capricorn:",
                                 @"๐น": @":chart:",
                                 @"๐ธ": @":children_crossing:",
                                 @"๐ฆ": @":cinema:",
                                 @"๐": @":cl:",
                                 @"๐": @":clock1:",
                                 @"๐": @":clock10:",
                                 @"๐ฅ": @":clock1030:",
                                 @"๐": @":clock11:",
                                 @"๐ฆ": @":clock1130:",
                                 @"๐": @":clock12:",
                                 @"๐ง": @":clock1230:",
                                 @"๐": @":clock130:",
                                 @"๐": @":clock2:",
                                 @"๐": @":clock230:",
                                 @"๐": @":clock3:",
                                 @"๐": @":clock330:",
                                 @"๐": @":clock4:",
                                 @"๐": @":clock430:",
                                 @"๐": @":clock5:",
                                 @"๐?": @":clock530:",
                                 @"๐": @":clock6:",
                                 @"๐ก": @":clock630:",
                                 @"๐": @":clock7:",
                                 @"๐ข": @":clock730:",
                                 @"๐": @":clock8:",
                                 @"๐ฃ": @":clock830:",
                                 @"๐": @":clock9:",
                                 @"๐ค": @":clock930:",
                                 @"ใ": @":congratulations:",
                                 @"๐": @":cool:",
                                 @"ยฉ": @":copyright:",
                                 @"โฐ": @":curly_loop:",
                                 @"๐ฑ": @":currency_exchange:",
                                 @"๐": @":customs:",
                                 @"๐?": @":diamond_shape_with_a_dot_inside:",
                                 @"๐ฏ": @":do_not_litter:",
                                 @"8โฃ": @":eight:",
                                 @"โด": @":eight_pointed_black_star:",
                                 @"โณ": @":eight_spoked_asterisk:",
                                 @"๐": @":end:",
                                 @"โฉ": @":fast_forward:",
                                 @"5โฃ": @":five:",
                                 @"4โฃ": @":four:",
                                 @"๐": @":free:",
                                 @"โ": @":gemini:",
                                 @"#โฃ": @":hash:",
                                 @"๐": @":heart_decoration:",
                                 @"โ": @":heavy_check_mark:",
                                 @"โ": @":heavy_division_sign:",
                                 @"๐ฒ": @":heavy_dollar_sign:",
                                 @"โ": @":heavy_minus_sign:",
                                 @"โ": @":heavy_multiplication_x:",
                                 @"โ": @":heavy_plus_sign:",
                                 @"๐": @":id:",
                                 @"๐": @":ideograph_advantage:",
                                 @"โน": @":information_source:",
                                 @"โ": @":interrobang:",
                                 @"๐": @":keycap_ten:",
                                 @"๐": @":koko:",
                                 @"๐ต": @":large_blue_circle:",
                                 @"๐ท": @":large_blue_diamond:",
                                 @"๐ถ": @":large_orange_diamond:",
                                 @"๐": @":left_luggage:",
                                 @"โ": @":left_right_arrow:",
                                 @"โฉ": @":leftwards_arrow_with_hook:",
                                 @"โ": @":leo:",
                                 @"โ": @":libra:",
                                 @"๐": @":link:",
                                 @"โ": @":m:",
                                 @"๐น": @":mens:",
                                 @"๐": @":metro:",
                                 @"๐ด": @":mobile_phone_off:",
                                 @"โ": @":negative_squared_cross_mark:",
                                 @"๐": @":new:",
                                 @"๐": @":ng:",
                                 @"9โฃ": @":nine:",
                                 @"๐ณ": @":no_bicycles:",
                                 @"โ": @":no_entry:",
                                 @"๐ซ": @":no_entry_sign:",
                                 @"๐ต": @":no_mobile_phones:",
                                 @"๐ท": @":no_pedestrians:",
                                 @"๐ญ": @":no_smoking:",
                                 @"๐ฑ": @":non-potable_water:",
                                 @"โญ": @":o:",
                                 @"๐พ": @":o2:",
                                 @"๐": @":ok:",
                                 @"๐": @":on:",
                                 @"1โฃ": @":one:",
                                 @"โ": @":ophiuchus:",
                                 @"๐ฟ": @":parking:",
                                 @"ใฝ": @":part_alternation_mark:",
                                 @"๐": @":passport_control:",
                                 @"โ": @":pisces:",
                                 @"๐ฐ": @":potable_water:",
                                 @"๐ฎ": @":put_litter_in_its_place:",
                                 @"๐": @":radio_button:",
                                 @"โป": @":recycle:",
                                 @"๐ด": @":red_circle:",
                                 @"ยฎ": @":registered:",
                                 @"๐": @":repeat:",
                                 @"๐": @":repeat_one:",
                                 @"๐ป": @":restroom:",
                                 @"โช": @":rewind:",
                                 @"๐": @":sa:",
                                 @"โ": @":sagittarius:",
                                 @"โ": @":scorpius:",
                                 @"ใ": @":secret:",
                                 @"7โฃ": @":seven:",
                                 @"๐ถ": @":signal_strength:",
                                 @"6โฃ": @":six:",
                                 @"๐ฏ": @":six_pointed_star:",
                                 @"๐น": @":small_blue_diamond:",
                                 @"๐ธ": @":small_orange_diamond:",
                                 @"๐บ": @":small_red_triangle:",
                                 @"๐ป": @":small_red_triangle_down:",
                                 @"๐": @":soon:",
                                 @"๐": @":sos:",
                                 @"๐ฃ": @":symbols:",
                                 @"โ": @":taurus:",
                                 @"3โฃ": @":three:",
                                 @"โข": @":tm:",
                                 @"๐": @":top:",
                                 @"๐ฑ": @":trident:",
                                 @"๐": @":twisted_rightwards_arrows:",
                                 @"2โฃ": @":two:",
                                 @"๐น": @":u5272:",
                                 @"๐ด": @":u5408:",
                                 @"๐บ": @":u55b6:",
                                 @"๐ฏ": @":u6307:",
                                 @"๐ท": @":u6708:",
                                 @"๐ถ": @":u6709:",
                                 @"๐ต": @":u6e80:",
                                 @"๐": @":u7121:",
                                 @"๐ธ": @":u7533:",
                                 @"๐ฒ": @":u7981:",
                                 @"๐ณ": @":u7a7a:",
                                 @"๐": @":underage:",
                                 @"๐": @":up:",
                                 @"๐ณ": @":vibration_mode:",
                                 @"โ": @":virgo:",
                                 @"๐": @":vs:",
                                 @"ใฐ": @":wavy_dash:",
                                 @"๐พ": @":wc:",
                                 @"โฟ": @":wheelchair:",
                                 @"โ": @":white_check_mark:",
                                 @"โช": @":white_circle:",
                                 @"๐ฎ": @":white_flower:",
                                 @"๐ณ": @":white_square_button:",
                                 @"๐บ": @":womens:",
                                 @"โ": @":x:",
                                 @"0โฃ": @":zero:"
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

//ๅๅฎนๆพๅบๅฏนๅบ็็ฌ่ธ
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

//็ฌ่ธๆพๅบๅฏนๅบ็ๅๅฎน
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

//ๅญ็ฌฆไธฒ ่ฝฌUnicode
+ (NSString *)utf8ToUnicode:(NSString *)string{
    NSUInteger length = [string length];
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++){
        NSMutableString *s = [NSMutableString stringWithCapacity:0];
        unichar _char = [string characterAtIndex:i];
        // ๅคๆญๆฏๅฆไธบ่ฑๆๅๆฐๅญ
        if (_char <= '9' && _char >='0'){
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }else if(_char >='a' && _char <= 'z'){
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }else if(_char >='A' && _char <= 'Z'){
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }else{
            // ไธญๆๅๅญ็ฌฆ
            [s appendFormat:@"\\u%x",[string characterAtIndex:i]];
            // ไธ่ถณไฝๆฐ่กฅ0 ๅฆๅ่งฃ็?ไธๆๅ
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

//Unicode ่ฝฌๅญ็ฌฆไธฒ
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

//ๆ็ฌฌไธๆฌกๅบ็ฐ็ไปไน่ฝฌๆขๆไปไน๏ผๅ้ขๅบ็ฐ็ไธ่ฝฌๆข
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

//ๆๆๅไธๆฌกๅบ็ฐ็ไปไน่ฝฌๆขๆไปไน๏ผๅ้ขๅบ็ฐ็ไธ่ฝฌๆข
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
    // ๆฅๆพๅๆฐ
    NSRange range = [urlStr rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    // ไปฅๅญๅธๅฝขๅผๅฐๅๆฐ่ฟๅ
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // ๆชๅๅๆฐ
    NSString *parametersString = [urlStr substringFromIndex:range.location + 1];
    // ๅคๆญๅๆฐๆฏๅไธชๅๆฐ่ฟๆฏๅคไธชๅๆฐ
    if ([parametersString containsString:@"&"]) {
        // ๅคไธชๅๆฐ๏ผๅๅฒๅๆฐ
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        for (NSString *keyValuePair in urlComponents) {
            // ็ๆKey/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            // Keyไธ่ฝไธบnil
            if (key == nil || value == nil) {
                continue;
            }
            id existValue = [params valueForKey:key];
            if (existValue != nil) {
                // ๅทฒๅญๅจ็ๅผ๏ผ็ๆๆฐ็ป
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // ๅทฒๅญๅจ็ๅผ็ๆๆฐ็ป
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    // ้ๆฐ็ป
                    [params setValue:@[existValue, value] forKey:key];
                }
            } else {
                // ่ฎพ็ฝฎๅผ
                [params setValue:value forKey:key];
            }
        }
    } else {
        // ๅไธชๅๆฐ
        // ็ๆKey/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        // ๅชๆไธไธชๅๆฐ๏ผๆฒกๆๅผ
        if (pairComponents.count == 1) {
            return nil;
        }
        // ๅ้ๅผ
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        // Keyไธ่ฝไธบnil
        if (key == nil || value == nil) {
            return nil;
        }
        // ่ฎพ็ฝฎๅผ
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
            NSLog(@"ๅญ็ฌฆไธฒไธญๅซๆๅคงๅ่ฑๆๅญๆฏ");
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
            NSLog(@"ๅญ็ฌฆไธฒไธญๅซๆๅฐๅ่ฑๆๅญๆฏ");
            return NO;
        }
    }
    return YES;
}

//ๅฐๅๅญๆฏ่ฝฌๆขๆๅคงๅ๏ผๅคงๅๅญๆฏ่ฝฌๆขๆๅฐๅ
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

//ๅญๆฏ่ฝฌๆๆๅคงๅ
- (NSString *)uppercaseInPlace{
    return  [self uppercaseString];
}

//ๅญๆฏ่ฝฌๆๆๅฐๅ
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

// ๅญๅธ่ฝฌjsonๅญ็ฌฆไธฒๆนๆณ
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
    //ๅปๆๅญ็ฌฆไธฒไธญ็็ฉบๆ?ผ
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //ๅปๆๅญ็ฌฆไธฒไธญ็ๆข่ก็ฌฆ
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
            NSLog(@"json่งฃๆๅคฑ่ดฅ๏ผ%@",err);
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
 *  @brief ๆฏๅฆๅๅซๅญ็ฌฆไธฒ
 *
 *  @param string ๅญ็ฌฆไธฒ
 *
 *  @return YES, ๅๅซ; Otherwise
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
    NSArray *chinese_numerals = @[@"ไธ",@"ไบ",@"ไธ",@"ๅ",@"ไบ",@"ๅญ",@"ไธ",@"ๅซ",@"ไน",@"้ถ"];
    NSArray *digits = @[@"ไธช",@"ๅ",@"็พ",@"ๅ",@"ไธ",@"ๅ",@"็พ",@"ๅ",@"ไบฟ",@"ๅ",@"็พ",@"ๅ",@"ๅ"];
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

/* ๆ็ดขไธคไธชๅญ็ฌฆไน้ด็ๅญ็ฌฆไธฒ */
+ (NSString *)searchInString:(NSString *)string charStart:(char)start charEnd:(char)end{
    int inizio = 0;
    int stop = 0;
    for(int i = 0; i < [string length]; i++){
        // ๅฎไฝ่ตท็น็ดขๅผๅญ็ฌฆ
        if([string characterAtIndex:i] == start){
            inizio = i + 1;
            i += 1;
        }
        // ๅฎไฝ็ปๆ็ดขๅผๅญ็ฌฆ
        if([string characterAtIndex:i] == end){
            stop = i;
            break;
        }
    }
    stop -= inizio;
    // ่ฃๅชๅญ็ฌฆไธฒ
    NSString *string2 = [[string substringFromIndex:inizio - 1] substringToIndex:stop + 1];
    return string2;
}

/**
 *  @brief ่ทๅๅญ็ฌฆๆฐ้
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
    
    //ๆ่
    //    NSLog(@"%lu",[str lengthOfBytesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)]);
    
    //ๆ่  ๅฆๆ่ฟไธชๅญ็ฌฆไธฒ๏ผ@"ๆ12โบ34"๏ผไธ้ขๆนๆณ่ฟๅ10๏ผๆญคๆนๆณๆพๅ8
    //    for (NSUInteger i = 0; i < str.length; i++) {
    //        unichar uc = [str characterAtIndex: i];
    //        asciiLength += isascii(uc) ? 1 : 2;
    //    }
    
    //ๆ่
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
            //ๅฐๆฐไฝๆๅฐไฟ็10ไฝๅฐๆฐ
            formatter.minimumFractionDigits = 10;
            changeString = [formatter stringFromNumber:value];
        }
            break;
        case NSNumberFormatterCurrencyStyle:
        {
            //ๆฅๆถ็่ดงๅธๅ็ปๅ้็ฌฆ ๅชๆNSNumberFormatterCurrencyStyleไธๆๆ็จ(้ป่ฎคๆฏ,ๆนๆ//)
            formatter.currencyGroupingSeparator = @"//";
            changeString = [formatter stringFromNumber:value];
        }
            break;
        case NSNumberFormatterPercentStyle:
        {
            //ๅฐ12.3็ๆ12.3%
            //็ผฉๆพๅ?ๅญ,ไฝ?ๅฏไปฅๅฐไธไธชๆฐ็ผฉๆพๆๅฎๆฏไพ,็ถๅ็ปๅถๆทปๅ?ๅ็ผ
            //็ผฉๆพๅ?ๅญ,ไฝ?ๅฏไปฅๅฐไธไธชๆฐ็ผฉๆพๆๅฎๆฏไพ,็ถๅ็ปๅถๆทปๅ?ๅ็ผ,ๅฆไผ?ๅฅไธไธช3000,ไฝ?ๅธๆ่กจ็คบไธบ3ๅ,ๅฐฑ่ฆ็จๅฐ่ฟไธชๅฑๆง
            //    formatter.multiplier = @1000;
            //    NSLog(@"%@ๅ",[formatter numberFromString:@"1000"]);  // 1ๅ
            
            //   formatter.multiplier     = @0.001;
            //   formatter.positiveSuffix = @"ๅ";
            //   NSLog(@"%@",[formatter stringFromNumber:@10000]);    // 10ๅ
            formatter.multiplier = @1.0f;
            //ๆฅๆถๅจ็จๆฅ่กจ็คบ็พๅๆฏ็ฌฆๅท็ๅญ็ฌฆไธฒใ(้ป่ฎคๆฏ%,ๆนๆ%%)
            formatter.percentSymbol = @"็พๅไน";
            //ๆๅฐไฟ็2ไฝๅฐๆฐ็น
            formatter.minimumFractionDigits = 2;
            changeString = [formatter stringFromNumber:value];
        }
            break;
        case NSNumberFormatterScientificStyle:
        {
            //ๆฅๆถๅจ็จๆฅ่กจ็คบๆๆฐ็ฌฆๅท็ๅญ็ฌฆไธฒ (้ป่ฎคๆฏE)ใ
            formatter.exponentSymbol = @"ee";
            //        formatter.currencyCode                     // ่ดงๅธไปฃ็?USD
            //        formatter.currencySymbol                   // ่ดงๅธ็ฌฆๅท$
            //        formatter.internationalCurrencySymbol   // ๅฝ้่ดงๅธ็ฌฆๅทUSD
            //        formatter.perMillSymbol                   // ๅๅๅท็ฌฆๅทโฐ
            //        formatter.minusSign                         // ๅๅท็ฌฆๅท-
            //        formatter.plusSign                          // ๅ?ๅท็ฌฆๅท+
            changeString = [formatter stringFromNumber:value];
        }
            break;
        case NSNumberFormatterSpellOutStyle:
        {
            //ๅฐๆฐๅผ0ๆนๆ้ถ
            formatter.zeroSymbol = @"้ถ";
            changeString = [formatter stringFromNumber:value];
        }
            break;
        case NSNumberFormatterDecimalStyle:
        {
            //            //1.ๅฆๆๆฏ่ดๆฐ็ๆถๅ็ๅ็ผ ็จ่ฟไธชๅญ็ฌฆไธฒไปฃๆฟ้ป่ฎค็"-"ๅท
            //            //formatter.positivePrefix = @"!";
            //            //formatter.negativeSuffix = @"ไบ";
            //            formatter.negativePrefix = @"่ดๆฐ";
            
            //            //2.ๆดๆนๅฐๆฐ็นๆ?ทๅผ
            //            formatter.decimalSeparator = @"ใ";
            
            //            //3.ๆฐๅญๅๅฒ็ๅฐบๅฏธ ๅฐฑๆฏๅฆๆฐๅญ่ถๅค1234 ไธบไบๆนไพฟๅฐฑๅๅฒๅผ 1,234(่ฟไธชๅๅฒ็ๅคงๅฐๆฏ3) ไปๅๅพๅๆฐ
            //            formatter.groupingSize = 2;
            //            //ไธไบๅบๅๅ่ฎธ่พๅคง็ๆฐๅญ็ๅฆไธไธชๅ็ปๅคงๅฐ็่ง่ใไพๅฆ๏ผๆไบๅฐๆนๅฏ่ฝไปฃ่กจไธไธชๆฐๅญๅฆ61๏ผ242๏ผ378.46๏ผๅจ็พๅฝ๏ผไฝไธบ6,12, 42378.46ใๅจ่ฟ็งๆๅตไธ๏ผไบๆฌกๅ็ปๅคงๅฐ๏ผ่ฆ็ๅฐๆฐ็นๆ่ฟ็ๆฐๅญ็ป๏ผไธบ2
            //            //ๅฐๆฐ็นๅ็(ๅคงไบ้ถ็้จๅ)๏ผๅไปๅณๅพๅทฆๅๅฒgroupSize็๏ผๅฆๆๅฉไฝ็ๅจๆ็งsecondaryGroupingSize็ๅคงๅฐๆฅๅ
            //            formatter.secondaryGroupingSize = 1;
            
            //            //4.ๆ?ผๅผๅฎฝๅบฆ ๅบๆฅ็ๆฐๆฎๅ?ไฝๆฏ15ไธช ไพๅฆๆฏ 123,45.6 ๆ?ผๅผๅฎฝๅบฆๅฐฑๆฏ 8
            //            formatter.formatWidth = 15;
            //            //ๅกซๅ็ฌฆ ๆๆถๅๆ?ผๅผๅฎฝๅบฆๅคๅฎฝ๏ผไธๅคๅฐฑ็จๅกซๅ็ฌฆ*ๅกซๅ
            //            formatter.paddingCharacter = @"*";
            //            //ๅกซๅ็ฌฆ็ไฝ็ฝฎ
            //            formatter.paddingPosition = kCFNumberFormatterPadAfterSuffix;
            
//            //5.่ๅฅๆนๅผ
//            formatter.roundingMode = NSNumberFormatterRoundHalfUp;
//            // ่ๅฅๅผ ๆฏๅฆไปฅ1ไธบ่ฟไฝๅผ   123456.58 ๅไธบ 123457
//            formatter.roundingIncrement = @1;
            
            //6.ๅญ็ฌฆไธฒ่ฝฌๆ้้ฑๆ?ผๅผ  ๅฆ 57823092.9  ็ปๆ 57,823,092.90
            formatter.positiveFormat = @"###,##0.00";
            
            changeString = [formatter stringFromNumber:value];
        }
            break;
            // ๆดๆฐๆๅคไฝๆฐ
            //    changeFormatter.maximumIntegerDigits = 10;
            //    // ๆดๆฐๆๅฐไฝๆฐ
            //    changeFormatter.minimumIntegerDigits = 2;
            //    // ๅฐๆฐไฝๆๅคไฝๆฐ
            //    changeFormatter.maximumFractionDigits = 3;
            //    // ๆๅคงๆๆๆฐๅญไธชๆฐ
            //    changeFormatter.maximumSignificantDigits = 12;
            //    // ๆๅฐๆๆๆฐๅญไธชๆฐ
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

//ๆๆบๅทๅๆๅกๅ
- (BOOL)isMobileNumberClassification{
    /**
     * ๆๆบๅท็?:
     * 13[0-9], 14[0,4-9], 15[0-3, 5-9], 16[5-7],17[0-8], 18[0-9], 19[1,3,8,9]
     * ็งปๅจๅทๆฎต: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * ่้ๅทๆฎต: 130,131,132,155,156,185,186,145,176,1709
     * ็ตไฟกๅทๆฎต: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[04-9]|5[0-35-9]|6[5-7]|7[0-8]|8[0-9]|9[1389])\\d{8}$";
    /**
     * ไธญๅฝ็งปๅจ๏ผChina Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * ไธญๅฝ่้๏ผChina Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * ไธญๅฝ็ตไฟก๏ผChina Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    /**
     25         * ๅคง้ๅฐๅบๅบ่ฏๅๅฐ็ต้
     26         * ๅบๅท๏ผ010,020,021,022,023,024,025,027,028,029
     27         * ๅท็?๏ผไธไฝๆๅซไฝ
     28         */
    // ๅธฆๅบๅท
    NSString *PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    //ไธๅธฆๅบๅท
    NSString *PHSN = @"^[1-9]{1}[0-9]{5,8}$";
    if (([self isValidateByRegex:MOBILE]) || ([self isValidateByRegex:CM]) || ([self isValidateByRegex:CU]) || ([self isValidateByRegex:CT]) || ([self isValidateByRegex:PHS]) || ([self isValidateByRegex:PHSN])){
        return YES;
    } else{
        return NO;
    }
}

//้ฎ็ฎฑ
- (BOOL)isEmailAddress{
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self isValidateByRegex:emailRegex];
}

//็ฒพ็กฎ็่บซไปฝ่ฏๅท็?ๆๆๆงๆฃๆต
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
    // ็ไปฝไปฃ็?
    NSArray *areasArray = @[
                           @"11",//ๅไบฌๅธ|110000๏ผ
                           @"12",//ๅคฉๆดฅๅธ|120000๏ผ
                           @"13",//ๆฒณๅ็|130000๏ผ
                           @"14",//ๅฑฑ่ฅฟ็|140000๏ผ
                           @"15",//ๅ่ๅค่ชๆฒปๅบ|150000๏ผ
                           @"21",//่พฝๅฎ็|210000๏ผ
                           @"22",//ๅๆ็|220000๏ผ
                           @"23",//้ป้พๆฑ็|230000๏ผ
                           @"31",//ไธๆตทๅธ|310000๏ผ
                           @"32",//ๆฑ่็|320000๏ผ
                           @"33",//ๆตๆฑ็|330000๏ผ
                           @"34",//ๅฎๅพฝ็|340000๏ผ
                           @"35",//็ฆๅปบ็|350000๏ผ
                           @"36",//ๆฑ่ฅฟ็|360000๏ผ
                           @"37",//ๅฑฑไธ็|370000๏ผ
                           @"41",//ๆฒณๅ็|410000๏ผ
                           @"42",//ๆนๅ็|420000๏ผ
                           @"43",//ๆนๅ็|430000๏ผ
                           @"44",//ๅนฟไธ็|440000๏ผ
                           @"45",//ๅนฟ่ฅฟๅฃฎๆ่ชๆฒปๅบ|450000๏ผ
                           @"46",//ๆตทๅ็|460000๏ผ
                           @"50",//้ๅบๅธ|500000๏ผ
                           @"51",//ๅๅท็|510000๏ผ
                           @"52",//่ดตๅท็|520000๏ผ
                           @"53",//ไบๅ็|530000๏ผ
                           @"54",//่ฅฟ่่ชๆฒปๅบ|540000๏ผ
                           @"61",//้่ฅฟ็|610000๏ผ
                           @"62",//็่็|620000๏ผ
                           @"63",//้ๆตท็|630000๏ผ
                           @"64",//ๅฎๅคๅๆ่ชๆฒปๅบ|640000๏ผ
                           @"65",//ๆฐ็็ปดๅพๅฐ่ชๆฒปๅบ|650000๏ผ
                           @"71",//ๅฐๆนพ็๏ผ886)|710000,
                           @"81",//้ฆๆธฏ็นๅซ่กๆฟๅบ๏ผ852)|810000๏ผ
                           @"82",//ๆพณ้จ็นๅซ่กๆฟๅบ๏ผ853)|820000
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
                //ๆต่ฏๅบ็ๆฅๆ็ๅๆณๆง
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];
            }else {
                //ๆต่ฏๅบ็ๆฅๆ็ๅๆณๆง
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
                //ๆต่ฏๅบ็ๆฅๆ็ๅๆณๆง
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];
            }else {
                //ๆต่ฏๅบ็ๆฅๆ็ๅๆณๆง
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
                // ๅคๆญๆ?ก้ชไฝ
                M = [JYM substringWithRange:NSMakeRange(Y,1)];
                // ๆฃๆตID็ๆ?ก้ชไฝ
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
        NSRange range1 = [realName rangeOfString:@"ยท"];
        NSRange range2 = [realName rangeOfString:@"โข"];
        // ไธญๆ ยทๆ่ฑๆ โข
        if(range1.location != NSNotFound ||
           range2.location != NSNotFound ){
            //ไธ่ฌไธญ้ดๅธฆ `โข`็ๅๅญ้ฟๅบฆไธไผ่ถ่ฟ15ไฝ๏ผๅฆๆๆ้ฃๅฐฑ่ฎพ้ซไธ็น
            if ([realName length] > 15){
                result = NO;
            }
            whereString = @"^[\u4e00-\u9fa5]+[ยทโข][\u4e00-\u9fa5]+$";
        }else{
            //ไธ่ฌๆญฃๅธธ็ๅๅญ้ฟๅบฆไธไผๅฐไบ2ไฝๅนถไธไธ่ถ่ฟ8ไฝ๏ผๅฆๆๆ้ฃๅฐฑ่ฎพ้ซไธ็น
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

//่ฝฆ็
- (BOOL)isCarNumber{
    //่ฝฆ็ๅท:ๆนK-DE829 ้ฆๆธฏ่ฝฆ็ๅท็?:็ฒคZ-J499ๆธฏ
    //ๅถไธญ\u4e00-\u9fa5่กจ็คบunicode็ผ็?ไธญๆฑๅญๅทฒ็ผ็?้จๅ๏ผ\u9fa5-\u9fffๆฏไฟ็้จๅ๏ผๅฐๆฅๅฏ่ฝไผๆทปๅ?
//                           ^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$
    NSString *carRegex = @"^[\u4e00-\u9fff]{1}[a-zA-Z]{1}[-][a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fff]$";
    return [self isValidateByRegex:carRegex];
}

- (BOOL)ba_regularIsValidateCarType{
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    return [self isValidateByRegex:CarTypeRegex];
}

/** ้ถ่กๅกๅทๆๆๆง้ฎ้ขLuhn็ฎๆณ
 *  ็ฐ่ก 16 ไฝ้ถ่ๅก็ฐ่กๅกๅทๅผๅคด 6 ไฝๆฏ 622126๏ฝ622925 ไน้ด็๏ผ7 ๅฐ 15 ไฝๆฏ้ถ่ก่ชๅฎไน็๏ผ
 *  ๅฏ่ฝๆฏๅๅกๅ่ก๏ผๅๅก็ฝ็น๏ผๅๅกๅบๅท๏ผ็ฌฌ 16 ไฝๆฏๆ?ก้ช็?ใ
 *  16 ไฝๅกๅทๆ?ก้ชไฝ้็จ Luhm ๆ?ก้ชๆนๆณ่ฎก็ฎ๏ผ
 *  1๏ผๅฐๆชๅธฆๆ?ก้ชไฝ็ 15 ไฝๅกๅทไปๅณไพๆฌก็ผๅท 1 ๅฐ 15๏ผไฝไบๅฅๆฐไฝๅทไธ็ๆฐๅญไนไปฅ 2
 *  2๏ผๅฐๅฅไฝไน็งฏ็ไธชๅไฝๅจ้จ็ธๅ?๏ผๅๅ?ไธๆๆๅถๆฐไฝไธ็ๆฐๅญ
 *  3๏ผๅฐๅ?ๆณๅๅ?ไธๆ?ก้ชไฝ่ฝ่ขซ 10 ๆด้คใ
 */
- (BOOL)bankCardluhmCheck{
    //ๅๅบๆๅไธไฝ
    NSString *lastNum = [[self substringFromIndex:(self.length - 1)] copy];
    //ๅ15ๆ18ไฝ
    NSString *forwardNum = [[self substringToIndex:(self.length - 1)] copy];
    NSMutableArray *forwardArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < forwardNum.length; i++) {
        NSString *subStr = [forwardNum substringWithRange:NSMakeRange(i, 1)];
        [forwardArr addObject:subStr];
    }
    
    NSMutableArray * forwardDescArr = [[NSMutableArray alloc] initWithCapacity:0];
    //ๅ15ไฝๆ่ๅ18ไฝๅๅบๅญ่ฟๆฐ็ป
    for (int i = (int)(forwardArr.count - 1); i > -1; i--) {
        [forwardDescArr addObject:forwardArr[i]];
    }
    //ๅฅๆฐไฝ*2็็งฏ < 9
    NSMutableArray *arrOddNum = [[NSMutableArray alloc] initWithCapacity:0];
    //ๅฅๆฐไฝ*2็็งฏ > 9
    NSMutableArray *arrOddNum2 = [[NSMutableArray alloc] initWithCapacity:0];
    //ๅถๆฐไฝๆฐ็ป
    NSMutableArray *arrEvenNum = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i = 0; i < forwardDescArr.count; i++) {
        NSInteger num = [forwardDescArr[i] intValue];
        if (i % 2) {//ๅถๆฐไฝ
            [arrEvenNum addObject:[NSNumber numberWithInteger:num]];
        }else{//ๅฅๆฐไฝ
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
            //่พๅบ็ปๆ
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
    //ๆนๆณ1
//    // url้พๆฅ็่งๅ
//    NSString *urlPattern = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
//    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:urlPattern options:0 error:nil];
//    NSArray *results = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
//
//    // ้ๅ็ปๆ
//    for (NSTextCheckingResult *result in results) {
//        NSLog(@"%@ %@", NSStringFromRange(result.range), [self substringWithRange:result.range]);
//        return YES ;
//    }
//    return NO;
    
    //ๆนๆณ2
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

#pragma mark ๅคๆญไธๅๅซ็นๆฎ็ฌฆๅท
- (BOOL)isNumAndword {
    NSString *reges = @"^[A-Za-z0-9-.]+$";
    return [self isValidateByRegex:reges];
}

- (NSString *)removeSpecialCharacter {
    NSRange urgentRange = [self rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @",.๏ผใ ~๏ฟฅ#&<>ใใ()[]{}ใใ^@/๏ฟกยค|ยงยจใใใใ๏ฟ?๏ฟข๏ฟฃ~@#&*๏ผ๏ผโโ+|ใใ$_โฌ"]];
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

/* ๅฐๅๅญๆฏๅญ็ฌฆๆฐ้ */
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

/* ๅคงๅๅญๆฏๅญ็ฌฆๆฐ้ */
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

/* ๆฐๅญๅญ็ฌฆๆฐ้ */
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

/* ็ฌฆๅทๅญ็ฌฆๆฐ้ */
- (int)countSymbols{
    int count = 0;
    for (int i = 0; i < [self length]; i++){
        BOOL isSymbol = [[NSCharacterSet characterSetWithCharactersInString:@"`~!?@#$โฌยฃยฅยง%^&*()_+-={}[]:\";<>'โข\\|/"] characterIsMember:[self characterAtIndex:i]];
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
    //ๆฃๆฅๆๅๆฏๅฆๆไธไธชๆข่ก็ฌฆ
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
            //ๆ่ฟ่กๅฏนๅบ็ๆข่ก็ฌฆ็ปๅฟฝ็ฅ
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
        [numArr addObject:[NSString stringWithFormat:@",%@",temp]];//ๅพๅฐ็ๅๅบ็ๆฐๆฎ
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
        NSLog(@"้พๆฅไธบ็ฉบ๏ผ");
        return @[@"",@{}];
    }
    //ๅๆชๅ้ฎๅท
    NSArray *allElements = [urlString componentsSeparatedByString:@"?"];
    //ๅพset็ๅๆฐๅญๅธ
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(allElements.count == 2) {
        //ๆๅๆฐๆ่?ๅ้ขไธบ็ฉบ
        NSString *myUrlString = allElements[0];
        NSString *paramsString = allElements[1];
        //่ทๅๅๆฐๅฏน
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
            //ๆ? &ใurlๅชๆ?ๅไธไธชๅๆฐ
            NSString *singleParamString = paramsArray[0];
            NSArray *singleParamSet = [singleParamString componentsSeparatedByString:@"="];
            if(singleParamSet.count == 2) {
                NSString *key = singleParamSet[0];
                NSString *value = singleParamSet[1];
                if(key.length > 0 || value.length > 0) {
                    [params setObject:value.length > 0 ? value : @"" forKey:key.length > 0 ? key : @""];
                }
            }else{
                //้ฎๅทๅ้ขๅฅไนๆฒกๆ xxxx?  ๆ?้ๅค็
            }
        }
        //ๆดๅurlๅๅๆฐ
        return @[myUrlString,params];
    }else if(allElements.count > 2) {
        NSLog(@"้พๆฅไธๅๆณ๏ผ้พๆฅๅๅซๅคไธช\"?\"");
        return @[@"",@{}];
    }else{
        NSLog(@"้พๆฅไธๅๅซๅๆฐ๏ผ");
        return @[urlString,@{}];
    }
}

- (NSDictionary *)parameterWithUrlString:(NSString *)urlString {
    urlString = [urlString stringByRemovingPercentEncoding];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    NSURL *tempUrl = [NSURL URLWithString:urlString];
     //ไผ?ๅฅurlๅๅปบurl็ปไปถ็ฑป
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:tempUrl.absoluteString];
    //ๅ่ฐ้ๅๆๆๅๆฐ๏ผๆทปๅ?ๅฅๅญๅธ
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
    
    //2.ๆถ้ดๆณ
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%.0f",time];
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: length];
    for (int i = 0; i < length; i++) {
        [randomString appendFormat: @"%C", [alphabet characterAtIndex:arc4random_uniform((u_int32_t)[alphabet length])]];
    }
    
    //==> UUIDStringๅปๆๆๅไธ้กน,ๅๆผๆฅไธ"ๆถ้ดๆณ"-"้ๆบๅญ็ฌฆไธฒkRandomLengthไฝ"
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
    //่ก้ด่ท๏ผๅ็ดไธ็้ด่ท๏ผ
    paraStyle.lineSpacing = lineSpacing;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0,self.length)];
    //่ฎพ็ฝฎๅญ้ด่ท
    [attributeString addAttribute:NSKernAttributeName value:@(wordSpacing) range:NSMakeRange(0,self.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,self.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributeString boundingRectWithSize:size
                                                options:options
                                                context:nil];
    //    NSLog(@"size:%@", NSStringFromCGSize(rect.size));
    //ๆๆฌ็้ซๅบฆๅๅปๅญไฝ้ซๅบฆๅฐไบ็ญไบ่ก้ด่ท๏ผๅคๆญไธบๅฝๅๅชๆ1่ก
    if((rect.size.height - font.lineHeight) <= paraStyle.lineSpacing) {
        //ๅฆๆๅๅซไธญๆ
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
