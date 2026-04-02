{
6- Se desea modelar la información necesaria para un sistema de recuentos de casos de
covid para el ministerio de salud de la provincia de buenos aires.
Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad casos
activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.
El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad casos activos, cantidad casos
nuevos, cantidad recuperados y cantidad de fallecidos.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.
Para la actualización se debe proceder de la siguiente manera:
1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2. Idem anterior para los recuperados.
3. Los casos activos se actualizan con el valor recibido en el detalle.
4. Idem anterior para los casos nuevos hallados.

Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).
}

program ejercicio6;

const
  dimf = 10;
  max = 50;
  valorGrande = 9999;

type
  
  municipio = record
    cod_localidad, cod_cepa, cant_casos_act, cant_casos_nue, cant_casos_recu, cant_casos_fall: integer;
  end;
 
  archivo1 = file of municipio;
  municipios = array [1..dimf] of archivo1;
  reg_det = array [1..dimf] of municipio;
 
  dat = record
    nom_loc, nom_cepa: string;
    cod_localidad, cod_cepa, cant_casos_act, cant_casos_nue, cant_recup, cant_fallecidos: integer;
  end;
  
  archivo2 = file of dat;
  
  procedure leer1(var arch: archivo1; var muni: municipio);
    begin
      if (not(EOF(arch))) then
        read(arch, muni)
      else
        muni.cod_localidad := valorGrande;
    end;
  
  procedure leer2(var arch: archivo2; var d: dat);
    begin
      if (not(EOF(arch))) then 
        read(arch, d)
     else
        d.cod_localidad := valorGrande;
    end;
  
  procedure cargar(var v: municipios; var v2: reg_det);
    var
      nombre: string;
      i: integer;
    begin
      for i:=1 to dimf do
        begin
          readln(nombre);
          assign(v[i], nombre);
          reset(v[i]);
          leer1(v[i], v2[i]);
        end;
    end;
    
  //-----------------------------------------------------------------------------
  procedure minimo(var v: municipios; var min: municipio; var v2: reg_det);
    var
      i, pos, cod1, cod2: integer;
      
    begin
      pos := -1;
      cod1 := valorGrande;
      cod2 := valorGrande;
      
      for i:=1 to dimf do
        begin
          if (v2[i].cod_localidad < cod1) or ((v2[i].cod_localidad = cod1) and (v2[i].cod_cepa < cod2)) then
            begin
              cod1 := v2[i].cod_localidad;
              cod2 := v2[i].cod_cepa;
              pos := i;
              min := v2[pos];
            end;
        end;
      if (pos <> -1) then
        leer1(v[pos], v2[pos]);
    end;
    
  procedure cerrar(var v: municipios);
    var
      i: integer;
    begin
      for i:=1 to dimf do
        close(v[i]);
    end;
    
  procedure actualizar(var v: municipios; var m: archivo2);
    var
      min: municipio;
      v2: reg_det;
      loc, cepa, fall, rec, casos_nue, casos_act: integer;
      d: dat;
    
    begin
      cargar(v, v2);
      assign(m, 'maestro');
      reset(m);
      
      minimo(v, min, v2);
      leer2(m, d);
      while (min.cod_localidad <> valorGrande) do
        begin
          loc := min.cod_localidad;
          cepa := min.cod_cepa;
          rec:= 0;
          fall := 0;
          casos_nue := 0;
          casos_act := 0;
          while (min.cod_localidad = loc) and (min.cod_cepa = cepa) do
            begin
              rec := rec + min.cant_casos_recu;
              fall := fall + min.cant_casos_fall;
              casos_nue := casos_nue + min.cant_casos_nue; 
              casos_act := casos_act + min.cant_casos_act;
              
              minimo(v, min, v2);
            end;
          
          {supongo que se recibe info de todos los municipios si o si, pero igual uso while}
          while (d.cod_localidad <> valorGrande) and (d.cod_cepa <> valorGrande) and ((d.cod_localidad <> loc) or (d.cod_cepa <> cepa)) do //no estoy seguro
            leer2(m,d);
   
          d.cant_recup := d.cant_recup + rec; //2
          d.cant_fallecidos := d.cant_fallecidos + fall; //1
          d.cant_casos_nue := casos_nue; //4      //no estoy seguro de este
          d.cant_casos_act := casos_act; //3
          
          seek(m, filepos(m)-1);
          write(m, d);
        end;
      cerrar(v);
      close(m);
    end;
  
  procedure informar(var m: archivo2);
    var
      d: dat;
      cont, total: integer;
    begin
      total := 0;
      reset(m);    
      leer2(m, d);
      while (d.cod_localidad <> valorGrande) do      
        begin
          cod := d.cod_localidad;
          cont := 0;
          while (d.cod_localidad = cod) do
            begin
              cont := cont + d.cant_casos_act;
              leer2(m, d);
            end;
          if (cont > max) then
            total := total +1;
        end;     
      writeln(total);
      close(m);
    end;
    
var
  v: municipios;
  m: archivo2;

begin
  actualizar(v, m);
  informar(m);
end.  
