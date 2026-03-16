{
10. Se tiene información en un archivo de las horas extras realizadas por los empleados de
una empresa en un mes. Para cada empleado se tiene la siguiente información:
departamento, división, número de empleado, categoría y cantidad de horas extras
realizadas por el empleado. Se sabe que el archivo se encuentra ordenado por
departamento, luego por división, y por último, por número de empleados. Presentar en
pantalla un listado con el siguiente formato:

Departamento
División
Número de Empleado                Total de Hs.         Importe a cobrar
...... .......... .........
...... .......... .........
Total de horas división: ____
Monto total por división: ____

División
.................

Total horas departamento: ____

Monto total departamento: ____

Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía
de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número
de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la
posición del valor coincidente con el número de categoría.
}

program ejercicio10;

const
  valorGrande = 'ZZZ';
  dimf = 15;

type
  rango = 1..dimf;

  empleado = record
    dep, division, hsDivision: string;
    nro, cant_hs_extras: integer;
    cat: 1..dimf;
  end;
  
  archivo = file of empleado;
  
  texto = text;

  valor_hora_extra = array[rango] of real;
  
procedure cargar_vec(var arch: text; var v: valor_hora_extra);
var
  cat: integer;
  valor: real;
begin
  reset(arch);
  while not eof(arch) do
  begin
    readln(arch, cat, valor);   { leo categoría y valor }
    v[cat] := valor;            { guardo el valor en la posición correspondiente }
  end;
  close(arch);
end;
  
  procedure leer(var arch: archivo; var em: empleado);
    begin
      if (not(EOF(arch))) then
        read(arch, em)
      else
        em.dep := valorGrande;
    end;
    
  procedure mostrar(var arch: archivo; v: valor_hora_extra);
    var
      dep, division: string;
      nro, total_gen, total_em, hsDivision: integer;
      em: empleado;
      total_monto: real;
      cat_em : rango;
    
    begin
      reset(arch); //mejor aca o en el ppl? ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      leer(arch, em);    
      while (em.dep <> valorGrande) do
        begin
          total_gen := 0;
          total_monto := 0;
          dep := em.dep;
          writeln('departamento: ',dep);
          
          while (dep = em.dep) do
            begin
              division := em.division;
              writeln('division: ', division);
              hsDivision := 0;
              
              while (dep = em.dep) and (division = em.division) do
                begin
                  nro := em.nro;
                  cat_em := em.cat;
                  write('nro de empleado: ', nro);
                  total_em := 0;
                  while (dep = em.dep) and (division = em.division) and (nro = em.nro) do
                    begin
                      total_em := total_em + em.cant_hs_extras;
                      leer(arch, em);                   
                    end;
                  write('         total de hs: ', total_em);
                  writeln('         importe a cobrar: ', total_em * v[cat_em]); 
                  total_monto := total_monto + (total_em * v[cat_em]);
                  hsDivision := hsDivision + total_em; 
                end;
			  writeln('total de hs de division; ', hsDivision);
              total_gen := total_gen + hsDivision;
            end;
          writeln('hs de departamento: ', total_gen);
          writeln('monto total de dep: ', totaL_monto);
        end; 
    end;

var
  txt: texto;
  arch: archivo;
  v: valor_hora_extra;
begin
  assign(arch, 'empleados');
  assign(txt, 'horas.txt');
  
  cargar_vec(txt, v);
  mostrar(arch, v);

end.
