//
//  CustomPickView.m
//  legend
//
//  Created by heyk on 16/1/11.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "CustomPickView.h"
#import "UitlCommon.h"
#import "RecieveAddressModel.h"

#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

typedef NS_ENUM(NSInteger,CustomPickType){
    
    CustomPickType_Date,
    CustomPickType_SingleRow,
    CustomPickType_Province,
};
@interface CustomPickView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong)NSArray *pickDataArray;
@property (nonatomic,strong)NSArray *cityArray;
@property (nonatomic,strong)NSArray *distrctArray;

@property (nonatomic,strong)RecieveAddressModel *selectAddresssModel;
@property (nonatomic,strong)RecieveAddressModel *oldAddresssModel;

@property (nonatomic,strong)NSString *selectValue;
@property (nonatomic,strong)NSString *oldValue;
@property (nonatomic,copy)CustomPickSelect selectBlock;
@property (nonatomic,copy)CustomPickValueChange valueChangeBlock;
@property (nonatomic,copy)CustomPickDisSelect disSelectBock;


@end

@implementation CustomPickView{
    
    CustomPickType currentType;
    UIView *contentView;
    UITapGestureRecognizer *tap;
    
    
    UIDatePicker *datePicker;
    UIPickerView *pickView;
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

+(CustomPickView*)getInstance{
    
    static CustomPickView *customPickView = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        customPickView = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
    });
    return customPickView;
    
}

-(void)showDatePick:(NSString*)currentValue   select:(CustomPickSelect)selectBlock disSelect:(CustomPickDisSelect)disSelect{
    
    currentType = CustomPickType_Date;
    self.oldValue = currentValue;
    self.selectBlock = selectBlock;
    self.disSelectBock = disSelect;
    
    
    [self setUI];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect frame = contentView.frame;
        frame.origin.y = DeviceMaxHeight - 180*widthRate-42*widthRate;
        contentView.frame = frame;
        
    } completion:^(BOOL finished) {
        
    }];
    
}



-(void)showPick:(NSString*)currentValue data:(NSArray*)data valueChange:(CustomPickValueChange)changeBlock select:(CustomPickSelect)selectBlock disSelect:(CustomPickDisSelect)disSelect{
    
    currentType = CustomPickType_SingleRow;
    self.selectValue = currentValue;
    self.oldValue = currentValue;;
    self.pickDataArray = data;
    self.selectBlock = selectBlock;
    self.disSelectBock = disSelect;
    self.valueChangeBlock = changeBlock;
    
    [self setUI];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect frame = contentView.frame;
        frame.origin.y = DeviceMaxHeight - 180*widthRate-42*widthRate;
        contentView.frame = frame;
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}


-(void)showProvicePick:(NSString*)currentValue valueChange:(CustomPickValueChange)changeBlock select:(CustomPickSelect)selectBlock disSelect:(CustomPickDisSelect)disSelect;{
    
    currentType = CustomPickType_Province;
    
    
    self.selectBlock = selectBlock;
    self.disSelectBock = disSelect;
    self.valueChangeBlock = changeBlock;
    
    RecieveAddressModel *model = [FrankTools getAddressModelWithDistrctID:currentValue];
    
    self.pickDataArray = [FrankTools getProvince];
    if (!model) {
        model = [RecieveAddressModel new];
        model.area_id = currentValue;
        model.provice = [_pickDataArray firstObject];
    }
    self.cityArray = [FrankTools getCityWithProvice:model.provice];
    if (!model.city ) {
        model.city = [_cityArray firstObject];
    }
    
    self.distrctArray = [FrankTools getDistrctWithProvice:model.provice city:model.city];
    if (!model.distrct) {
        model.distrct = [self.distrctArray firstObject];
    }

    self.selectAddresssModel = model;
    self.oldAddresssModel = model;
    
    [self setUI];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect frame = contentView.frame;
        frame.origin.y = DeviceMaxHeight - 180*widthRate-42*widthRate;
        contentView.frame = frame;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)showLocationPick:(NSString*)currentValue valueChange:(CustomPickValueChange)changeBlock select:(CustomPickSelect)selectBlock disSelect:(CustomPickDisSelect)disSelect{

    
    currentType = CustomPickType_Province;
    
    
    self.selectBlock = selectBlock;
    self.disSelectBock = disSelect;
    self.valueChangeBlock = changeBlock;
    
    RecieveAddressModel *model = [FrankTools getAddressModelWithDistrctID:currentValue];
    
    NSMutableArray *reuslt = [NSMutableArray arrayWithObjects:@"全部", nil];
    [reuslt addObjectsFromArray:[FrankTools getProvince]];
    
    self.pickDataArray = reuslt;
    
    if (!model) {
        model = [RecieveAddressModel new];
        model.area_id = currentValue;
        model.provice = [_pickDataArray firstObject];
    }
    self.cityArray = [FrankTools getCityWithProvice:model.provice];
    if (!model.city ) {
        model.city = [_cityArray firstObject];
    }
    
    self.distrctArray = [FrankTools getDistrctWithProvice:model.provice city:model.city];
    if (!model.distrct) {
        model.distrct = [self.distrctArray firstObject];
    }
    
    self.selectAddresssModel = model;
    self.oldAddresssModel = model;
    
    [self setUI];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect frame = contentView.frame;
        frame.origin.y = DeviceMaxHeight - 180*widthRate-42*widthRate;
        contentView.frame = frame;
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)setUI{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    if (contentView) {
        [contentView removeFromSuperview];
        contentView = nil;
    }
    if (tap) {
        [self removeGestureRecognizer:tap];
        tap = nil;
    }
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBack)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DeviceMaxHeight + 180*widthRate+42*widthRate, DeviceMaxWidth,  180*widthRate+42*widthRate)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    
    if (currentType == CustomPickType_Date) {
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,0, DeviceMaxWidth, 160)];
        [contentView addSubview:datePicker];
        
        
        NSTimeZone *systemTimeZone = [NSTimeZone systemTimeZone];
        [datePicker setTimeZone:systemTimeZone];//设置时区
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        NSDate *use_date = [NSDate date];
        
        NSString *oldValueStr = self.oldValue ;
        
        if (oldValueStr.length > 0) {
            NSString *dateStr = oldValueStr;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            use_date= [dateFormatter dateFromString:dateStr];
        }
        [datePicker setDate:use_date];
        //最小时间
        [datePicker setMinimumDate:[NSDate dateWithTimeIntervalSince1970:0]];
        //最大时间为当前时间
        [datePicker setMaximumDate:[NSDate date]];
        
    }
    else if(currentType == CustomPickType_SingleRow){
        pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,0, DeviceMaxWidth, 160)];
        pickView.delegate = self;
        pickView.dataSource = self;
        [contentView addSubview:pickView];
        
        
        NSString *oldValue = self.oldValue ;
        
        for (int j = 0; j<self.pickDataArray.count; j++) {
            NSString *str = [self.pickDataArray  objectAtIndex:j];
            if ([str isEqualToString:oldValue]) {
                
                [pickView selectRow:j inComponent:0 animated:YES];
                break;
            }
        }
    }
    else if(currentType == CustomPickType_Province){
        pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,0, DeviceMaxWidth, 160)];
        pickView.delegate = self;
        pickView.dataSource = self;
        [contentView addSubview:pickView];
        [self reloadProvice:self.selectAddresssModel];
    }
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = mainColor;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16*widthRate];
    button.frame = CGRectMake(0, contentView.frame.size.height-42*widthRate, DeviceMaxWidth, 42*widthRate);
    [button addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:button];
    
    [[[UIApplication sharedApplication].windows lastObject] addSubview:self];
}

-(void)selectClick:(UIButton*)button{
    
    if (self.selectBlock) {
        
        if (currentType == CustomPickType_Date) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateStr = [dateFormatter stringFromDate:datePicker.date];
            self.selectBlock(dateStr);
        }
        else if(currentType == CustomPickType_SingleRow){
            NSMutableString *selectValue = [NSMutableString string];
            [selectValue appendString:self.selectValue];
            self.selectBlock(selectValue);
        }
        else if(currentType == CustomPickType_Province){
            
            NSString *zipCode = [FrankTools getDistrctIDWithModel:self.selectAddresssModel];
            _selectAddresssModel.area_id = zipCode;
            self.selectBlock(self.selectAddresssModel);
        }
        
    }
    
    [self dismiss];
    
}

-(void)tapBack{
    
    if (self.disSelectBock) {
        if (currentType == CustomPickType_Province) {
            
            self.disSelectBock(self.oldAddresssModel);
        }
        else{
            NSString *oldValueStr = self.oldValue;
            self.disSelectBock(oldValueStr);
        }
 
    }
    
    [self dismiss];
}

-(void)dismiss{
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         CGRect frame = contentView.frame;
                         frame.origin.y = DeviceMaxHeight + 180*widthRate+42*widthRate;
                         contentView.frame = frame;
                         
                     } completion:^(BOOL finished) {
                         
                         [contentView removeFromSuperview];
                         contentView = nil;
                         
                         [self removeGestureRecognizer:tap];
                         tap = nil;
                         
                         [self removeFromSuperview];
                     }];
}

#pragma mark - UIPickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {//设置picker有几个模块
    
    if ( currentType ==CustomPickType_SingleRow) {
        return 1;
    }
    else if(currentType ==CustomPickType_Province){
        return 3;
    }
    
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {//每个模块中有几行
    
    if ( currentType ==CustomPickType_SingleRow) {
        return _pickDataArray.count;
    }
    
    else if (currentType ==CustomPickType_Province){
        
        if (component == PROVINCE_COMPONENT) {//省
            return [_pickDataArray count];
        }
        else if(component == CITY_COMPONENT){//市
            
            return [_cityArray count];
            
        }
        else if(component == DISTRICT_COMPONENT){//区
            return [_distrctArray count];
            
        }
        
    }
    
    return 0;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {//行高
    return 45;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {//设置文字
    
    UILabel *retval= [[UILabel alloc] initWithFrame:view.bounds];
    retval.lineBreakMode = NSLineBreakByWordWrapping;
    retval.numberOfLines = 0;
    [retval setFont:[UIFont systemFontOfSize:21]];
    retval.textAlignment = NSTextAlignmentCenter;
    [retval setBackgroundColor:[UIColor clearColor]];
    
    if ( currentType ==CustomPickType_SingleRow) {
        NSString *str = [_pickDataArray objectAtIndex:row];
        retval.text = str;
    }
    else if(currentType == CustomPickType_Province){
        
        if (component == PROVINCE_COMPONENT) {
            
            NSString *str = [_pickDataArray objectAtIndex:row];
            retval.text = str;
        }
        else if (component == CITY_COMPONENT) {
            NSString *str = [_cityArray objectAtIndex:row];
            retval.text = str;
        }
        else {
            NSString *str = [_distrctArray objectAtIndex:row];;
            retval.text = str;
        }
    }
    return retval;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {//选择后操作
    
    if (currentType == CustomPickType_SingleRow) {
        NSString *str = [_pickDataArray objectAtIndex:row];
        self.selectValue = str;
        if (self.valueChangeBlock) {
            self.valueChangeBlock(str,component);
        }
    }
    else if(currentType == CustomPickType_Province){
    
        if (component == PROVINCE_COMPONENT) {
       
            NSString *proviceStr = [_pickDataArray objectAtIndex:row];
            self.cityArray = [FrankTools getCityWithProvice:proviceStr];
            NSString *cityStr = [_cityArray firstObject];
            self.distrctArray = [FrankTools getDistrctWithProvice:proviceStr city:cityStr];
            
            RecieveAddressModel *model = [RecieveAddressModel new];
            model.provice  = proviceStr;
            model.city = cityStr;
            
            model.distrct = [self.distrctArray firstObject];
            self.selectAddresssModel = model;
            
            [self reloadProvice:_selectAddresssModel];
            
        }
        else if (component == CITY_COMPONENT) {

            NSString *cityStr = [_cityArray objectAtIndex:row];
            self.selectAddresssModel.city = cityStr;
            self.distrctArray = [FrankTools getDistrctWithProvice:self.selectAddresssModel.provice city:cityStr];
            self.selectAddresssModel.distrct = [self.distrctArray firstObject];
            
            [self reloadProvice:_selectAddresssModel];
        }
        else if (component == DISTRICT_COMPONENT) {

            NSString *areStr = [_distrctArray objectAtIndex:row];
            self.selectAddresssModel.distrct = areStr;
            
        }
    }
}


-(void)reloadProvice:(RecieveAddressModel*)model{

    NSUInteger provinceRow = [_pickDataArray indexOfObject:model.provice];
    NSUInteger cityRow = [_cityArray indexOfObject:model.city];
    NSUInteger districtRow = [_distrctArray indexOfObject:model.distrct];
    
    [pickView reloadComponent:CITY_COMPONENT];
    [pickView reloadComponent:DISTRICT_COMPONENT];
    
    [pickView selectRow:provinceRow inComponent:PROVINCE_COMPONENT animated:NO];
    [pickView selectRow:cityRow inComponent:CITY_COMPONENT animated:YES];
    [pickView selectRow:districtRow inComponent:DISTRICT_COMPONENT animated:YES];
    


}

@end
