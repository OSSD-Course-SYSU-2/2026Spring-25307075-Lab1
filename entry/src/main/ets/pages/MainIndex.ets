import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { CheckInManager } from '../common/bean/CheckInManager';
@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State checkCount: number = 0; // 打卡总次数
  aboutToAppear() {
    // ...已有初始化代码...

    // 在已有代码下方添加 ↓↓↓
    CheckInManager.getCheckInCount().then(count => {
      this.checkCount = count;
    });
  }
  build() {
    Column() {
      Column() {
        Button('打卡')
          .width(140)
          .height(140)
          .fontSize(20)
          .fontColor(Color.White)
          .backgroundColor('#409EFF')
          .borderRadius(70)
          .onClick(async () => {
            const newCount = await CheckInManager.saveCheckIn();
            this.checkCount = newCount;
          })

        Text(`已打卡: ${this.checkCount}次`)
          .fontSize(18)
          .margin({ top: 16 })
      }
      .margin({ top: 40 })
      .alignItems(HorizontalAlign.Center)
      // 添加结束 ↑↑↑
      Text($r('app.string.Kit')).fontWeight(FontWeight.Bold).fontSize(40);
      Button($r('app.string.ExerciseSequence')).width('50%').onClick(() => {
        this.getUIContext().getRouter().pushUrl({
          url: 'pages/ExerciseSequenceIndex'
        }).catch((err: BusinessError) => {
          hilog.error(0x0000, 'testTag', `Failed to pushUrl. Code: ${err.code}, message: ${err.message}`);
        })
      });
      Button($r('app.string.Auth')).width('50%').onClick(() => {
        this.getUIContext().getRouter().pushUrl({
          url: 'pages/AuthIndex'
        }).catch((err: BusinessError) => {
          hilog.error(0x0000, 'testTag', `Failed to pushUrl. Code: ${err.code}, message: ${err.message}`);
        })
      });
    }.alignItems(HorizontalAlign.Center).height('100%').width('100%')
    .justifyContent(FlexAlign.SpaceEvenly)
  }
}