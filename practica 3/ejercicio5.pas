{
5. Dada la estructura planteada en el ejercicio anterior, implemente el siguiente módulo:
[[[[[[[[Abre el archivo y elimina la flor recibida como parámetro manteniendo
la política descripta anteriormente]]]]]]]]]]
procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);
}

program ejercicio4;

type
  reg_flor = record
    nombre: String[45];
    codigo:integer;
  end;
  
  tArchFlores = file of reg_flor;
  
  procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer);
    var
      r, r_aux: reg_flor;
      pos: integer;
      
    begin
      reset(a);
  
      if (not(EOF(a))) then
        begin
          r.codigo := codigo;
          r.nombre := nombre;
          read(a, r_aux);
          if (r_aux.codigo = 0) then
            begin
              seek(a, filesize(a));           
              write(a, r);
            end
          else
            begin
              pos := r_aux.codigo * -1;
              seek(a, pos);
              
              read(a, r_aux);
              seek(a, 0);
              write(a, r_aux);
              
              seek(a, pos);
              write(a, r);
            end;
        end;
      close(a);
    end;
    
  //5
  procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);
    var
      r: reg_flor;
      pos: integer;
      ok: boolean;
      
    begin
      reset(a);
      ok := true;
      
      { Salto de la cabecera para no buscar sobre el puntero de la pila }
      seek(a, 1);
      while (not(EOF(a)) and (ok)) do
        begin
          read(a, r);
          if (r.codigo = flor.codigo) then
            ok := false;  
        end;
      if (ok = false) then
        begin
          pos := filepos(a)-1;
          
          // Paso A: Leer cabecera
          seek(a, 0);
          read(a, r); // cabecera(r) ahora tiene el enlace anterior (ej: un -5 o un 0)
                      
          // Paso B: El registro borrado hereda lo que decía la cabecera
          seek(a, pos);
          write(a, r); // Ahora el registro 8 "apunta" al que seguía (al 5)
                        
          // Paso C: La cabecera apunta al nuevo hueco
          r.codigo := pos * -1; 
          seek(a, 0);
          write(a, r);       
        end;
      close(a);
    end;
    
var
  a: tArchFlores;
  cod: integer;
  nom: string[45];
  
begin
  readln(cod);
  readln(nom);
  agregarFlor(a, nom, cod);
end.
