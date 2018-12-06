//
/*!
 *  @header RecordManager.h
 *
 *  @abstract 录音控制对象
 *
 *  @author Actions Semi.
 */

/*!
 *  @protocol RecordDelegate
 *
 *  @discussion {@link RecordManager}对象的代理需遵循 <code>RecordDelegate</code>协议.
 */
@protocol RecordDelegate <NSObject>

/*!
 *  @method managerReady:
 *
 *  @param mode 设备当前的模式
 *
 *  @abstract {@link RecordManager}对象准备就绪
 *
 *  @seealso FuncMode
 */
-(void)managerReady:(UInt32)mode;
/*!
 *  @method recordTimeHour:minute:second:
 *
 *  @param hour 录音时间：时
 *  @param minute 录音时间：分
 *  @param second 录音时间：秒
 *
 *  @abstract 录音事事件更新
 */
-(void)recordTimeHour:(UInt32)hour minute:(UInt32)minute second:(UInt32)second;
/*!
 *  @method recordStateChanged:
 *
 *  @param state 当前状态
 *
 *  @abstract 录音当前状态变化
 */
-(void)recordStateChanged:(UInt32)state;

@end

/*!
 *  @protocol RecordManager
 *
 *  @discussion 录音控制接口，通过{@link BluzManager}的接口来获取。
 */
@protocol RecordManager <NSObject>

/*!
 *  @method start
 *
 *  @abstract 开始录音
 */
-(void)start;
/*!
 *  @method pause:
 *
 *  @abstract 暂停录音
 */
-(void)pause;
/*!
 *  @method stop
 *
 *  @abstract 结束录音
 */
-(void)stop;

@end
