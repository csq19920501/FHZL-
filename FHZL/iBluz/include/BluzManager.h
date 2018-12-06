/*!
 *  @header BluzManager.h
 *
 *  @abstract Bluz控制对象
 *
 *  @author Actions Semi.
 */

#import <Foundation/Foundation.h>
#import "BluzDevice.h"
#import "GlobalManager.h"
#import "MusicManager.h"
#import "RadioManager.h"
#import "AlarmManager.h"
#import "AuxManager.h"
#import "RecordManager.h"
#import "USBSpeakerManager.h"

@protocol OutputDelegate;

/*!
 *  @class BluzManager
 *
 *  @abstract 获取各应用模式管理接口
 *
 *  @discussion 需在重新得到新的{@link BluzDevice}对象后重新构造
 */
@interface BluzManager : NSObject<OutputDelegate, TimeoutDelegate>

/*!
 *  @method initWithConnector:
 *
 *  @param connector 远程连接设备{@link BluzDevice}
 *
 *  @return 类对象
 *
 *  @abstract 构造函数
 */
-(id)initWithConnector:(BluzDevice *)connector;
/*!
 *  @method getGlobalManager:
 *
 *  @param delegate GlobalManager协议
 *
 *  @return 全局管理对象
 *
 *  @abstract 获取{@link GlobalManager}全局管理对象
 */
-(id<GlobalManager>)getGlobalManager:(id<GlobalDelegate>)delegate;
/*!
 *  @method getMusicManager:
 *
 *  @param delegate MusicManager协议
 *
 *  @return 音箱播放管理对象
 *
 *  @abstract 获取{@link MusicManager}音箱播放管理对象
 */
-(id<MusicManager>)getMusicManager:(id<MusicDelegate>)delegate;
/*!
 *  @method getRadioManager:
 *
 *  @param delegate RadioManager协议
 *
 *  @return 收音机管理对象
 *
 *  @abstract 获取{@link RadioManager}收音机管理对象
 */
-(id<RadioManager>)getRadioManager:(id<RadioDelegate>)delegate;
/*!
 *  @method getAlarmManager:
 *
 *  @param delegate AlarmManager协议
 *
 *  @return 闹钟管理对象
 *
 *  @abstract 获取{@link AlarmManager}闹钟管理对象
 */
-(id<AlarmManager>)getAlarmManager:(id<AlarmDelegate>)delegate;
/*!
 *  @method getAuxManager:
 *
 *  @param delegate AuxManager协议
 *
 *  @return Linein管理对象
 *
 *  @abstract 获取{@link AuxManager}Aux管理对象
 */
-(id<AuxManager>)getAuxManager:(id<AuxDelegate>)delegate;
/*!
 *  @method getRecordManager:
 *
 *  @param delegate RecordManager协议
 *
 *  @return 录音管理对象
 *
 *  @abstract 获取{@link RecordManager}录音管理对象
 */
-(id<RecordManager>)getRecordManager:(id<RecordDelegate>)delegate;
/*!
 *  @method getUSBSpeakerManager:
 *
 *  @param delegate USBSpeakerManager协议
 *
 *  @return USB音箱管理对象
 *
 *  @abstract 获取{@link USBSpeakerManager}USB音箱管理对象
 */
-(id<USBSpeakerManager>)getUSBSpeakerManager:(id<USBSpeakerDelegate>)delegate;
/*!
 *  @method close
 *
 *  @abstract 清理Manager环境
 */
- (void)close;
@end
