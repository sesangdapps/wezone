//
//  NSObject_GALBaseController.h
//  Langtudy
//
//  Created by SinSuMin on 2015. 9. 3..
//  Copyright (c) 2015년 galuster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GALBaseController.h"


//#import "GALCallParam.h"


//#import "GALAssessController.h"


@implementation GALBaseController{
    GALToastView *msgToast;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-  (void)viewDidLoad{
    
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated{
//    [[SDXmppManager sharedInstance] setDelegate:self];
}

- (NSString *) getStringWithKey:(NSString *)key{
    return NSLocalizedString(key,key);
}

- (void) goBackinLogin{
    [ApplicationDelegate.loginNaviController popViewControllerAnimated:YES];
}

- (void) goBackinMain{
    [ApplicationDelegate.mainNaviController popViewControllerAnimated:YES];
}

- (void) goBackinMainTwice{
    [ApplicationDelegate.mainNaviController  popToViewController:[[ApplicationDelegate.mainNaviController viewControllers] objectAtIndex:2] animated:YES];
}

- (void) goBackinMainThreeStep{
    [ApplicationDelegate.mainNaviController  popToViewController:[[ApplicationDelegate.mainNaviController viewControllers] objectAtIndex:1] animated:YES];
}

- (void)didReceiveMessageWithToId:(NSString *)toId fromId:(NSString *)fromId dataType:(NSString *)dataType data:(NSString *)data{
    
}

- (void) didReceiveMessage:(NSString *)body{
    
    NSString *strTemp = [body base64DecodedString];
    strTemp = [strTemp stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    strTemp = [GALangtudyUtils percentDecodingString:strTemp];
    
    msgToast = [GALToastView toastView];
    [msgToast showWithIcon:[UIImage imageNamed:@"nopicture"] Title:@"메세지" Text:strTemp target:self selector:@selector(onClickMessage)];
  
}

- (void) didReceiveCommandWithToId:(NSString *)toId FromId:(NSString *)fromId Resource:(NSString *)resource DataType:(NSString *)dataType Data:(NSString *)data{
    
    
}

- (void) didReceiveMessageWithToId:(NSString *)toId FromId:(NSString *)fromId Contents:(NSString *)contents MessageType:(NSString *)message_type ItemId:(NSString *)item_id LangtudyType:(NSString *)langtudy_type UserUuid:(NSString *)user_uuid UserName:(NSString *)user_name UserImageUrl:(NSString *)user_img_url FromMode:(NSString *)from_mode LangCode:(NSString *)lang_code UsedCost:(NSString *)used_cost LangCoinSessionId:(NSString *)langcoin_sesstion_id ScheduleId:(NSString *)schedule_id ScheduleDate:(NSString *)schedule_date ScheduleItemCount:(NSString *)schedule_item_cnt{

    
//    if(([MESSAGE_TYPE_SCHEDULE isEqualToString:message_type] || [MESSAGE_TYPE_REVIEW isEqualToString:message_type]) &&
//       ([@"98" isEqualToString:langtudy_type] || [@"99" isEqualToString:langtudy_type])){
//        return;
//    }
//    
//    if([MESSAGE_TYPE_CHAT isEqualToString:message_type]){
//        
//        NSString *strTemp = [contents base64DecodedString];
//        strTemp = [strTemp stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        strTemp = [GALangtudyUtils percentDecodingString:strTemp];
//        
//        msgToast = [GALToastView toastView];
//        [msgToast showWithImageUrl:user_img_url Title:user_name Text:strTemp target:self selector:@selector(onClickMessage)];
//        
//    }else if([MESSAGE_TYPE_CALL isEqualToString:message_type]){
//        
//        
//        if([STATE_REQUEST isEqualToString:item_id]){
//            
//            NSString *mode = @"T";
//            if([@"T" isEqualToString:from_mode]){
//                mode = @"L";
//            }
//            
//            GALCallParam *param = [GALCallParam new];
//            [param setOtherUserUuid:user_uuid];
//            [param setUserName:user_name];
//            [param setUserImgUrl:user_img_url];
//            [param setFromMode:from_mode];
//            [param setLangCode:lang_code];
//            [param setUsedCost:used_cost];
//            [param setLangCoinSesstionId:langcoin_sesstion_id];
//            [param setScheduleId:schedule_id];
//            [param setScheduleDate:schedule_date];
//            [param setScheduleItemCnt:schedule_item_cnt];
//            
//            ARTCVideoChatViewController *mARTCVideoChatViewController = [[ARTCVideoChatViewController alloc] initWithCallMode:CALL_MODE_RESPONSE CallParam:param];
//            [mARTCVideoChatViewController setDelegate:self];
//            [ApplicationDelegate.mainNaviController presentViewController:mARTCVideoChatViewController animated:YES completion:^{
//                
//            }];
//        }
//        
//    }
    
}

//- (void) goToAssessController:(GALCallParam *) callParam{
//    GALAssessController *mGALAssessController = [[GALAssessController alloc] initWithCallParam:callParam];
//    [ApplicationDelegate.mainNaviController pushViewController:mGALAssessController animated:YES];
//}
//
//- (void) onClickMessage{
//    [msgToast __hide];
//}
//
//- (void) sendUserStatus:(NSString *)status{
//    [self sendUserStatus:status OtherUuid:nil CallOption:nil resultBloc:^(NSString *user_uuid, NSString *remains) {
//       
//    }];
//}
//
//- (void) sendUserStatus:(NSString *)status OtherUuid:(NSString *)other_user_uuid CallOption:(GALCallOption *)option resultBloc:(userStatusBlock) resultBlock{
//    
//    NSString *user_uuid = ApplicationDelegate.loginData.user_info.user_uuid;
//    
//    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
//    
//    [engine updateUserStatusithUserUuid:user_uuid UserState:status OtherUuid:other_user_uuid CallOption:option resultHandler:resultBlock errorHandler:^(NSDictionary *data, NSError *error) {
//        
//    }].isDisableActivityIndicator = YES;
//}
//
//- (void) didXmppAuthenticate{
//    [self sendUserStatus:USER_STATUS_ON];
//}

@end
