{
6. Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con
la información correspondiente a las prendas que se encuentran a la venta. De cada
prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las
prendas a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las
prendas que quedarán obsoletas. Deberá implementar un procedimiento que reciba

ambos archivos y realice la baja lógica de las prendas, para ello deberá modificar el
stock de la prenda correspondiente a valor negativo.
Adicionalmente, deberá implementar otro procedimiento que se encargue de
efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la
información de las prendas a la venta. Para ello se deberá utilizar una estructura
auxiliar (esto es, un archivo nuevo), en el cual se copien únicamente aquellas prendas
que no están marcadas como borradas. Al finalizar este proceso de compactación
del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro
original.
}

program ejercicio6;

type
  prenda = record 
    cod_prenda, stock: integer;
    descripcion, colores, tipo_prenda: string;
    precio_unitario:real;
  end;

  archivo = file of prenda;

  archivo2 = file of integer; // archivo prendas cod obseleto
  archivo_nuevo = file of prenda;

  procedure procedimiento1(var a1: archivo; var a2: archivo2);
    var
      p_aux: prenda;
      cod: integer;
      ok: boolean;
    
    begin
      reset(a1);
      reset(a2);
      
      while (not(EOF(a2))) do
        begin 
          read(a2, cod);
          seek(a1, 0); // Vuelvo al inicio para buscar cada codigo
          ok := false;
                    
          while (not(EOF(a1)) and (ok = false)) do
            begin
              read(a1, p_aux);     
       
              if (cod = p_aux.cod_prenda) then
                begin
                  ok := true;
                  
                  p_aux.stock := -1;
                  seek(a1, filepos(a1)-1);
                  write(a1, p_aux);
                end;
            end;
         
        end;
      close(a1);
      close(a2);
    end;
    
  procedure procedimiento2(var a: archivo; var a2: archivo_nuevo);
    var
      p_aux: prenda;
      
    begin
      reset(a);
      rewrite(a2);
      
      while (not(EOF(a))) do
        begin 
          read(a, p_aux);
          if (p_aux.stock <> -1) then
            write(a2, p_aux);       
        end;
      close(a);
      close(a2);
    end;
    
var
  a: archivo;
  a2: archivo2;
  a3: archivo_nuevo;

begin
  assign(a, 'prendas');
  assign(a2, 'obsoletos');
  assign(a3, 'nuevo');
  
  procedimiento1(a, a2);
  procedimiento2(a, a3);
  assign(a3, 'prendas');
end.
