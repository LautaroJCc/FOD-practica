program ejercicio1;

type
  empleado = record
    cod: integer;
    nombre: string;
    monto: real;
  end;
  
  archivo = file of empleado;
  
  procedure nuevo(var arch: archivo; var arch2: archivo);
    var
      em, act: empleado;
    begin
      reset(arch);
      rewrite(arch2);

    if not EOF(arch) then //controla si esta vacio
      begin
        read(arch, em); 
        while not EOF(arch) do
          begin
            act.cod := em.cod;
            act.nombre := em.nombre;
            act.monto := 0;

            while (act.cod = em.cod) and (not EOF(arch)) do
              begin
                act.monto := act.monto + em.monto;
                read(arch, em);
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
  
