--@Autores:         Jorge Cárdenas Cárdenas
--                  Samuel Arturo Garrido Sánchez
--@Fecha creación:  16/08/2021
--@Descripción:     Main Triggers


create or replace trigger t_dml_archivo_programa
instead of insert or update or delete on archivo_programa
declare
begin 
  case
    when inserting then
      if :new.tamanio > 10 then
        
        insert into archivo_programa_f1(num_archivo,programa_id,archivo,tamanio)
        values(:new.num_archivo, :new.programa_id, :new.archivo, :new.tamanio);

      elsif :new.tamanio <= 10 then
        
        insert into archivo_programa_f2(num_archivo,programa_id,archivo,tamanio)
        values(:new.num_archivo, :new.programa_id, :new.archivo, :new.tamanio);

      else
        raise_application_error(-20010,
          'Valor incorrecto para el campo TAMANIO:'
        );
      end if;

    when updating then
      raise_application_error(-20030,
        'Operación UPDATE no soportada aún'
      );

    when deleting then
        if :new.tamanio > 10 then
        
        delete from archivo_programa_f1 where num_archivo = :old.num_archivo and programa_id = :old.programa_id;

      elsif :new.tamanio <= 10 then
        
        delete from archivo_programa_f2 where num_archivo = :old.num_archivo and programa_id = :old.programa_id;

      else
        raise_application_error(-20010,
          'Valor incorrecto para el campo TAMANIO:'
        );
      end if;
    end case;
  exception
   WHEN others THEN
   null;
  end;
/
show errors