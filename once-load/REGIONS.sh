# Получение текущей даты
current_date=$(date +%Y%m%d_%H%M)

# Формирование пустые данные в файл
echo "ID;BEGIN_TIME;END_TIME;DESCRIPTION;MCC;MNC" > /home/name/COPM/files/REGIONS_$current_date.txt


#
#
#   В таблицах данных нет, можно заполнить вручную по примеру ниже:
#       
   echo "6;2022-04-01 00:00:00;2049-12-12 23:59:00;ИП Шелухина Г.Л.;;" >> /home/name/COPM/files/REGIONS_$current_date.txt
#
