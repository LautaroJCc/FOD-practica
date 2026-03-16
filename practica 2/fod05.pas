{
5. A partir de un siniestro ocurrido se perdieron las actas de nacimiento y fallecimientos de
toda la provincia de buenos aires de los últimos diez años. En pos de recuperar dicha
información, se deberá procesar 2 archivos por cada una de las 50 delegaciones distribuidas
en la provincia, un archivo de nacimientos y otro de fallecimientos y crear el archivo maestro
reuniendo dicha información.

Los archivos detalles con nacimientos, contendrán la siguiente información: nro partida
nacimiento, nombre, apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula
del médico, nombre y apellido de la madre, DNI madre, nombre y apellido del padre, DNI del
padre.
En cambio, los 50 archivos de fallecimientos tendrán: nro partida nacimiento, DNI, nombre y
apellido del fallecido, matrícula del médico que firma el deceso, fecha y hora del deceso y
lugar.
Realizar un programa que cree el archivo maestro a partir de toda la información de los
archivos detalles. Se debe almacenar en el maestro: nro partida nacimiento, nombre,
apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula del médico, nombre y
apellido de la madre, DNI madre, nombre y apellido del padre, DNI del padre y si falleció,
además matrícula del médico que firma el deceso, fecha y hora del deceso y lugar. Se
deberá, además, listar en un archivo de texto la información recolectada de cada persona.

Nota: Todos los archivos están ordenados por nro partida de nacimiento que es única.
Tenga en cuenta que no necesariamente va a fallecer en el distrito donde nació la persona y
además puede no haber fallecido.
}

program ejercicio5;

const
  max_dia = 31;
  max_mes = 12;
  dimf = 50;
  valorGrande = 9999;

type
  direc = record
    calle, nro, piso: integer;
    depto, ciudad: string;
  end;

  nacimiento = record
    nro_part_nac, matricula_med, dni_madre, dni_padre: integer;
    nombre, apellido, nombre_madre, ape_madre, nombre_padre, ape_padre: string;
    direccion: direc;
  end;
  
  archivo1 = file of nacimiento;
  
  rango_dia = 0..max_dia;
  rango_mes = 0..max_mes;
  
  fecha = record
    dia: rango_dia;
    mes: rango_mes;
    anio: integer;
  end;
  
  fallecimiento = record
    nro_part_nac, dni, matri_med, hora_deceso: integer;
    ape, nom, lugar_deceso: string;
    fec: fecha;
  end;
  
  archivo2 = file of fallecimiento;
  
  mae = record
    info: nacimiento;
    fallecio: boolean;
    matri_med, hora_deceso: integer;
    lugar_deceso: string;
    fec: fecha;
  end;
  
  archivo3 = file of mae;
  
  nacimientos = array [1..dimf] of archivo1;
  fallecimientos = array [1..dimf] of archivo2;
  nac_registros = array [1..dimf] of nacimiento;
  fall_registros = array [1..dimf] of fallecimiento;
  
  texto = text;
  
  procedure leer(var arch: archivo1; var nac: nacimiento);
    begin
      if (not(EOF(arch))) then
        read(arch, nac)
      else
        nac.nro_part_nac := valorGrande;
    end;
    
  procedure leer2(var arch: archivo2; var fall: fallecimiento);
    begin
      if (not(EOF(arch))) then
        read(arch, fall)
      else
        fall.nro_part_nac := valorGrande;
    end;
  
  procedure iniciar(var v: nacimientos; var v2: fallecimientos; var v3: nac_registros; var v4: fall_registros);
    var
      i: integer;
      s: string;
    begin
      for i := 1 to dimF do
        begin
          str(i, s);
          assign(v[i], 'nacimiento' + s);
          assign(v2[i], 'fallecimiento' + s);
          reset(v[i]);
          reset(v2[i]);
          leer(v[i], v3[i]);
          leer2(v2[i], v4[i]);
        end;
    end;
    
  procedure minimoNac(var v: nacimientos; var v2: nac_registros; var minNac: nacimiento);
    var
      i, min, pos: integer;   
      
    begin
      min := 9999;
      pos := -1;
      for i:=1 to dimf do
        begin
          if (v2[i].nro_part_nac < min) then
            begin
              min := v2[i].nro_part_nac;
              pos := i;
              minNac := v2[i];
            end;
        
        end;
      if (pos <> -1) then
        leer(v[pos], v2[pos]);
    end;
    
  procedure minimoFall(var v: fallecimientos; var v2: fall_registros; var minFall: fallecimiento);
    var
      i, min, pos: integer;   
      
    begin
      min := 9999;
      pos := -1;
      for i:=1 to dimf do
        begin
          if (v2[i].nro_part_nac < min) then
            begin
              min := v2[i].nro_part_nac;
              pos := i;
              minFall := v2[i];
            end;
        
        end;
      if (pos <> -1) then
        leer2(v[pos], v2[pos]);
    end;
    
  procedure cerrar(var v: nacimientos; var v2: fallecimientos);
    var
      i: integer;
    begin
      for i:=1 to dimf do
        begin
          close(v[i]);
          close(v2[i]);
        end;
    end;
    
  procedure cargar_mae(var v: nacimientos; var v2: fallecimientos; var maestro: archivo3; var txt: texto);
    var
      v3: nac_registros;
      v4: fall_registros;
      minNac: nacimiento;
      minFall: fallecimiento;
      m: mae;
      
    begin
      rewrite(maestro);
      rewrite(txt);
      iniciar(v, v2, v3, v4);
      minimoNac(v, v3, minNac);
      minimoFall(v2, v4, minFall);    
      
      while (minNac.nro_part_nac <> valorGrande) do
        begin
          while (minFall.nro_part_nac <> valorGrande) and (minFall.nro_part_nac < minNac.nro_part_nac) do
            minimoFall(v2, v4, minFall);    
          
          m.info := minNac;
          if (minFall.nro_part_nac = minNac.nro_part_nac) then
            begin
              //agrego al maestro con datos de fallecido   
              m.fallecio := true;
              m.matri_med := minFall.matri_med;
              m.hora_deceso := minFall.hora_deceso;
              m.lugar_deceso := minFall.lugar_deceso;
              m.fec.dia := minFall.fec.dia;
              m.fec.mes := minFall.fec.mes;
              m.fec.anio := minFall.fec.anio;
              
              minimoFall(v2, v4, minFall); //avanzo fallecimiento
            end
          else
            begin
              //agrego al maestro solo nacimiento
              m.fallecio := false;
              m.matri_med := -1;
              m.hora_deceso := -1;
              m.lugar_deceso := '';
              m.fec.dia := 0;
              m.fec.mes := 0;
              m.fec.anio := 0;
              
            end;
          write(maestro, m);
          writeln(txt, m.info.nombre, ' ', m.info.apellido); //es mas pero japa
          minimoNac(v, v3, minNac); //avanzo nacimiento
        end;
      cerrar(v, v2);
      close(maestro);
      close(txt);
    end;
  
var
  v: nacimientos;
  v2: fallecimientos;
  maestro: archivo3;
  txt: texto;

begin
  assign(maestro, 'maestro');
  assign(txt, 'personas.txt');
  cargar_mae(v, v2, maestro, txt);
end.
    
    
  
