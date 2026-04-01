{
Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descripto y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.
}

//ejercicio probablemente correcto

program ejercicio1;

const
  valor_grande = 9999;

type
  empleado = record
    cod: integer;
    nombre: string;
    monto: real;
  end;
  
  archivo = file of empleado;

  procedure leer(var arch: archivo; var e: empleado);
    begin
      if (not(EOF(arch))) then
        read(arch, e)
      else
        e.cod := valor_grande;
    end;
  
  procedure nuevo(var arch: archivo; var arch2: archivo);
    var
      em, act: empleado;
    begin 
      reset(arch);
      rewrite(arch2);

      leer(arch, em);
      while (em.cod <> valor_grande) do
        begin
          act.cod := em.cod;
          act.nombre := em.nombre;
          act.monto := 0;

          while (act.cod = em.cod) do
            begin
              act.monto := act.monto + em.monto;
              leer(arch, em);
            end;

          write(arch2, act);
        end;

        close(arch);
        close(arch2);
      end;
    end;
  
var
  archivo_logico: archivo;
  arch2: archivo;
  
begin
  assign(archivo_logico, 'empleados');
  assign(arch2, 'empleados2');
  nuevo(archivo_logico, arch2);
end.
  
