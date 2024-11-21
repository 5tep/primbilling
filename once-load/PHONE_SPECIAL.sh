# Получение текущей даты
current_date=$(date +%Y%m%d_%H%M)

# Формирование пустые данные в файл
echo "PHONE_NUMBER;DESCRIPTION;BEGIN_TIME;END_TIME;IP_TYPE;IPV4;IPV6;REGION_ID" > /home/user/COPM/files/PHONE_SPECIAL_$current_date.txt


#
#
#   В таблицах данных нет, можно заполнить вручную по примеру ниже:
#       
   echo "1234567890;Техническая поддержка;2022-10-14 00:00:00;2049-12-31 23:59:59;;;;6" >> /home/user/COPM/files/PHONE_SPECIAL_$current_date.txt
#
