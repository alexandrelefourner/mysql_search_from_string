DELIMITER $$


-- From Willie Wheeler (with database adjustment) https://stackoverflow.com/users/41871/willie-wheeler

create function column_exists(databasename text, ptable text, pcolumn text)
  returns bool
  reads sql data
begin
  declare result bool;
  select
    count(*)
  into
    result
  from
    information_schema.columns
  where
    `table_schema` = databasename and
    `table_name` = ptable and
    `column_name` = pcolumn;
  return result;
end $$


CREATE PROCEDURE display_cols(database_name MEDIUMTEXT, tablename_input MEDIUMTEXT, my_entries MEDIUMTEXT)
BEGIN

	DECLARE next_c TEXT DEFAULT NULL;
	DECLARE nextlen INT DEFAULT NULL;
	DECLARE val TEXT DEFAULT NULL;
	DECLARE cols TEXT  DEFAULT NULL;
	DECLARE tablename TEXT  DEFAULT NULL;

	SET cols = "";
	
	
	SET next_c = SUBSTRING_INDEX(tablename_input,' ',1);
	SET tablename = TRIM(tablename_input);


	iterator:
	LOOP
		IF my_entries IS NULL OR LENGTH(TRIM(my_entries)) = 0 THEN
			LEAVE iterator;
		END IF;

		SET next_c = SUBSTRING_INDEX(my_entries,',',1);
		SET val = TRIM(next_c);

		IF column_exists(database_name, tablename, val) THEN 
			IF NOT LENGTH(cols) = 0 THEN
				SET cols = CONCAT(cols, ",");
			END IF;
		
		SET cols = CONCAT(cols, val);
		
		END IF;

		SET nextlen = LENGTH(next_c);

		SET my_entries = INSERT(my_entries,1,nextlen + 1,'');
	END LOOP;
	
	IF NOT cols = "" AND NOT cols IS NULL THEN
		SET @sql = CONCAT('SELECT ', cols, ' FROM ',tablename);
		PREPARE statement FROM @sql;
		EXECUTE statement;
	end if;
END $$

DELIMITER ;
