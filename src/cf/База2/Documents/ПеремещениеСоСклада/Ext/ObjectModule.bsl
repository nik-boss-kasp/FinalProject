﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	Отказ = ЛОЖЬ;
	Движения.ОстаткиНаСкладе.Записывать = Истина;
	Для Каждого ТекСтрокаСписокТМЦ Из СписокТМЦ Цикл  
		Отказ = ЕстьНаСкладе(ТекСтрокаСписокТМЦ.Номенклатура,ТекСтрокаСписокТМЦ.Количество, СкладОтправитель); 
		Если Отказ Тогда
			Сообщить("Не хватает остатка по " + ТекСтрокаСписокТМЦ.Номенклатура);
		КонецЕсли;
		Движение = Движения.ОстаткиНаСкладе.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Номенклатура = ТекСтрокаСписокТМЦ.Номенклатура;
		Движение.Склад = СкладОтправитель;
		Движение.Количество = ТекСтрокаСписокТМЦ.Количество;
	КонецЦикла;

	Движения.ОстаткиНаСкладе.Записывать = Истина;
	Для Каждого ТекСтрокаСписокТМЦ Из СписокТМЦ Цикл
		Движение = Движения.ОстаткиНаСкладе.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Номенклатура = ТекСтрокаСписокТМЦ.Номенклатура;
		Движение.Склад = СкладПолучатель;
		Движение.Количество = ТекСтрокаСписокТМЦ.Количество;
	КонецЦикла;

КонецПроцедуры

Функция ЕстьНаСкладе(Номенклатура, КолВо, Склад)
	Запрос = Новый ЗАпрос;
	ЗАпрос.Текст = 
	"ВЫБРАТЬ
	|	ОстаткиНаСкладеОстатки.Номенклатура КАК Номенклатура,
	|	ОстаткиНаСкладеОстатки.Склад КАК Склад,
	|	ОстаткиНаСкладеОстатки.КоличествоОстаток КАК КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.ОстаткиНаСкладе.Остатки(&Дата, ) КАК ОстаткиНаСкладеОстатки
	|ГДЕ
	|	ОстаткиНаСкладеОстатки.Номенклатура = &Номенклатура
	|	И ОстаткиНаСкладеОстатки.Склад = &Склад
	|	И ОстаткиНаСкладеОстатки.КоличествоОстаток >= &Количество";
	Запрос.УстановитьПараметр("Дата", текущаяДата());
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("Количество",КолВо);
	Результат = Запрос.Выполнить().Выбрать();
	Возврат НЕ Результат.Следующий();
КонецФункции
