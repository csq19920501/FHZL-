/*!
 *  @header USBSpeakerManager.h
 *
 *  @abstract USB音箱控制对象
 *
 *  @author Actions Semi.
 */


/*!
 *  @protocol AUSBSpeakerDelegate
 *
 *  @abstract {@link USBSpeakerManager}对象的代理需遵循 <code>USBSpeakerDelegate</code>协议.
 */
@protocol USBSpeakerDelegate <NSObject>

/*!
 *  @method managerReady:
 *
 *  @param mode   设备当前的模式
 *
 *  @abstract {@link USBSpeakerManager}对象准备就绪
 */
-(void)managerReady:(UInt32)mode;
/*!
 *  @method stateChanged:
 *
 *  @param state USB音箱当前状态
 *
 *  @abstract USB音箱状态变化
 */
-(void)stateChanged:(UInt32)state;

@end

/*!
 *  @protocol USBSpeakerManager
 *
 *  @abstract USBSpeaker管理接口，通过{@link BluzManager}的接口来获取。
 */
@protocol USBSpeakerManager <NSObject>

/*!
 *  @method play
 *
 *  @abstract 播放
 */
-(void)play;
/*!
 *  @method pause
 *
 *  @abstract 暂停
 */
-(void)pause;
/*!
 *  @method next
 *
 *  @abstract 下一首
 */
-(void)next;
/*!
 *  @method previous
 *
 *  @abstract 上一首
 */
-(void)previous;

@end
