{11. A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.}

program ejercicio11;

const
  valorGrande = 'ZZZ';
  dimf = 2;
  
type 
  dat = record
    nom_prov: string;
    cant_per_alf, total_encuestados: integer;
  end;
  
  maestro = file of dat;
  
  dat2 = record
    info: dat;
    cod_loc: integer;
  end;
  
  detalle = file of dat2;
  
  detalles = array [1..dimf] of detalle;
  reg_det = array [1..dimf] of dat2;
   
  procedure leer(var arch: detalle; var d: dat2);
    begin
      if (not(EOF(arch))) then
        read(arch, d)
      else
        d.info.nom_prov := valorGrande;
    end;
    
  procedure leer2(var arch: maestro; var d: dat);
    begin
      if (not(EOF(arch))) then
        read(arch, d)
      else
        d.nom_prov := valorGrande;
    end;
    
  procedure cargar(var v: reg_det; var v2: detalles);
    var
      i: integer;
      nombre: string;
    begin
      for i:=1 to dimf do
        begin
          write('ingrese nombre del archivo det: ');
          readln(nombre);
          assign(v2[i], nombre);
          reset(v2[i]);
          leer(v2[i], v[i]);
        end;
    end;
    
  procedure minimo(var v: reg_det; var v2: detalles; var minR: dat2);
    var
      i, pos: integer;
      prov_min: string;
      
    begin
      pos := -1;
      prov_min := valorGrande;
      for i:=1 to dimf do
        begin
          if (v[i].info.nom_prov < prov_min) then
            begin
              prov_min := v[i].info.nom_prov;
              pos := i;
              minR := v[pos];
            end;
        end;
      if (pos <> -1) then
        leer(v2[pos], v[pos]);
    end;
  
  
  procedure actualizar(var v: detalles; var m: maestro);  
    var
      minR, act: dat2;
      v2: reg_det;
      mae: dat;
      
    begin
      cargar(v2, v);
      minimo(v2, v, minR);
      reset(m);
      leer2(m, mae);
      while (minR.info.nom_prov <> valorGrande) do
        begin
          act.info.nom_prov := minR.info.nom_prov;
          act.cod_loc := minR.cod_loc; //inecesario
          act.info.total_encuestados := 0;
          act.info.cant_per_alf := 0;
          
          while (act.info.nom_prov = minR.info.nom_prov) do { Acumulo todos los registros que tienen la misma provincia }
            begin
              act.info.total_encuestados := act.info.total_encuestados + minR.info.total_encuestados;
              act.info.cant_per_alf := act.info.cant_per_alf + minR.info.cant_per_alf;
              
              minimo(v2, v, minR);
            end;
          
          {busco maestro}
          while (mae.nom_prov <> act.info.nom_prov) do
            leer2(m, mae);
          
          mae.total_encuestados := mae.total_encuestados + act.info.total_encuestados;
          mae.cant_per_alf := mae.cant_per_alf + act.info.cant_per_alf;
          
          //agrego
          seek(m, filepos(m)-1);
          write(m, mae);
        end;
      close(v[1]);
      close(v[2]);
      close(m);
    end;

var
  v: detalles;
  m: maestro;

begin
  assign(m, 'maestro');
  actualizar(v, m);
end.
