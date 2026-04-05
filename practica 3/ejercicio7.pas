{
7. Se cuenta con un archivo que almacena información sobre especies de aves en vía
de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las
especies a eliminar. Deberá realizar todas las declaraciones necesarias, implementar
todos los procedimientos que requiera y una alternativa para borrar los registros. Para
ello deberá implementar dos procedimientos, uno que marque los registros a borrar y
posteriormente otro procedimiento que compacte el archivo, quitando los registros
marcados. Para quitar los registros se deberá copiar el último registro del archivo en la
posición del registro a borrar y luego eliminar del archivo el último registro de forma tal
de evitar registros duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000
}

program ejercicio7;

const
  marca = -1;
  corte = 5000;

type
  ave = record 
    codigo: integer;
    nom_especie, familia_ave,descripcion, zona_geo: string;
  end;
  
  archivo = file of ave;
  
  procedure marcar_borrar(var a: archivo);
    var
      ave_aux: ave;
      cod: integer;
      ok: boolean;
    
    begin
      reset(a);
      
      readln(cod);
      while (cod <> corte) do
        begin 
          seek(a, 0); 
          ok := true;
          while (not(EOF(a))) and (ok) do
            begin
              read(a, ave_aux);
          
              if (ave_aux.codigo = cod) then
                begin
                  ok := false;
                  ave_aux.codigo := marca;
                  seek(a, filepos(a)-1);
                  write(a, ave_aux);
                end;             
             end;
          readln(cod);
        end;
      close(a);
    end;

  procedure compactar(var a: archivo);
    var
      ave_aux: ave;
      pos: integer;
    begin
      reset(a);
      
      while (not(EOF(a))) do
        begin
          read(a, ave_aux);
          
          if (ave_aux.codigo = marca) then
            begin
              pos := filepos(a)-1;
              seek(a, pos); //me posiciono en la pos que tiene el elemento a borrar
              
              //chequeo si es ultimo elemento o no
              if (pos = filesize(a)-1) then //si es ultimo lo borro y listo
                truncate(a)
              else //sino
                begin
                  seek(a, filesize(a)-1); //me posiciono al final
                  read(a, ave_aux);     //tomo el dato del final y lo guardo
                  seek(a, filesize(a)-1); //me posiciono al final
                  truncate(a);          //borro el final
                  
                  seek(a, pos);         //me vuelvo a posicionar EN LA POS QUE GUARDE
                  write(a, ave_aux);    //REESCRIBO CON EL ELEMENTO DEL ULTIMO
                  seek(a, pos);         //me vuelvo a posicionar EN LA POS QUE GUARDE
                end;
            end;
        end;
      close(a);
    end;
    
var
  a: Archivo;
  
begin
  assign(a, 'aves extinción');
  marcar_borrar(a);
  compactar(a);
end.
