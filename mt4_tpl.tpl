<chart>
id=131365144787425019
symbol=GBPUSD-2
period=30
leftpos=933
digits=5
scale=8
graph=0
fore=0
grid=1
volume=1
scroll=1
shift=1
ohlc=1
one_click=0
one_click_btn=1
askline=0
days=0
descriptions=0
shift_size=20
fixed_pos=0
window_left=26
window_top=26
window_right=1049
window_bottom=343
window_type=3
background_color=16777215
foreground_color=0
barup_color=0
bardown_color=0
bullcandle_color=16777215
bearcandle_color=0
chartline_color=0
volumes_color=32768
grid_color=12632256
askline_color=17919
stops_color=17919

<window>
height=100
fixed_height=0
<indicator>
name=main
</indicator>
<indicator>
name=Bollinger Bands
period=20
shift=0
deviations=2.000000
apply=0
color=7451452
style=0
weight=1
period_flags=0
show_data=1
</indicator>
<indicator>
name=Ichimoku Kinko Hyo
tenkan=9
kijun=26
senkou=52
color=255
style=0
weight=1
color2=16711680
style2=0
weight2=1
color3=65280
style3=0
weight3=1
color4=6333684
style4=2
weight4=1
color5=14204888
style5=2
weight5=1
period_flags=0
show_data=1
</indicator>
</window>

<window>
height=50
fixed_height=0
<indicator>
name=MACD
fast_ema=12
slow_ema=26
macd_sma=9
apply=0
color=12632256
style=0
weight=1
signal_color=255
signal_style=2
signal_weight=1
period_flags=0
show_data=1
</indicator>
<indicator>
name=Custom Indicator
<expert>
name=RSI
flags=275
window_num=1
<inputs>
InpRSIPeriod=14
</inputs>
</expert>
shift_0=0
draw_0=0
color_0=16748574
style_0=0
weight_0=0
min=0.00000000
max=100.00000000
levels_color=12632256
levels_style=2
levels_weight=1
level_0=30.00000000
level_1=70.00000000
period_flags=0
show_data=1
</indicator>
</window>
</chart>
