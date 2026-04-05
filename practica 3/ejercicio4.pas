program ejercicio4;

const
  valorGrande = 9999;

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

      r.codigo := codigo;
      r.nombre := nombre;   
      read(a, r_aux); // leo cabecera
      if (r_aux.codigo = 0) then 
        begin
          seek(a, filesize(a));           
          write(a, r);
        end
      else
        begin
          pos := -r_aux.codigo;
          
          seek(a, pos);
          read(a, r_aux);
          
          seek(a, 0);
          write(a, r_aux);
          
          seek(a, pos);
          write(a, r);
        end;
        
      close(a);
    end;
    
    //B zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
    
    procedure listarFlores(var a: tArchFlores);
      var
        r: reg_flor;
      begin
        reset(a);
        
        seek(a, 1);
        while (not EOF(a)) do
          begin
            read(a, r);
            if (r.codigo > 0) then
              writeln('Codigo: ', r.codigo, ' Nombre: ', r.nombre);
          end;
          
        close(a);
      end;
    
var
  a: tArchFlores;
  cod: integer;
  nom: string[45];
  
begin
  assign(a, 'flores');
  
  readln(cod);
  readln(nom);
  
  agregarFlor(a, nom, cod);
  listarFlores(a);
end.
