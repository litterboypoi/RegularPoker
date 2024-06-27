# 一些全局变量，能模块化的功能尽量把变量放在自己的模块内，这里尽量只存放一些零散的变量
extends Node

var is_dragging: bool = false
var is_selecting: bool = false

var dragging_select_card_datas: Array[CardData] = []
