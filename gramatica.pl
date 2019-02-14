% Realizado por: Carlos Montoto Jáuregui y David Savary Martínez

frase(Salida) --> gn(SUJ, _G, Persona, Numero),
				  gn(CI, _, _, _),
				  verbo(VER, _, Persona, Numero, _, _),
				  modo(Modo),
				  pregunta(Preg),
				  gn(SUJ_SUB, G, PersonaS, NumeroS),
				  verbo(VER_SUB, TiempoS, PersonaS, NumeroS, _, RaizS),
				  gn(CD, _, _, _),
				  complemento(C, LPrepC),
				  { componer(Salida, SUJ, CI, VER, SUJ_SUB, RaizS, CD, PersonaS, NumeroS, TiempoS, Modo, Preg, C)}.

% Sintagma nominal con determinante y sustantivo
gn([A, N], Genero, 3, Numero) --> [Al, N], {es_art(Al, Numero, Genero, A), es_nombre(N, Numero, Genero)}.

% Sintagma formado por nombre propio
gn([P], Genero, 3, singular) --> [P], {es_nombre_p(P, Genero)}.

% Sintagma formado por nombre
gn([P], Genero, 3, Numero) --> [P], {es_nombre(P, Numero, Genero)}.

% Sintagma nominal formado por pronombre
gn([P], _, Persona, Numero) --> [Pal], { es_pronombre(Pal, Persona, Numero, P) }.

% Sujeto omitido
gn([], _, _, _) --> [].

% Modo indirecto si está "que"
modo(Modo) --> [P], { es_indirecto(P)}.
modo([]) --> [].

% Pregunta si hay interrogante o "si" en la indirecta
pregunta(Preg) --> [P], { hay_pregunta(P)}.
pregunta([]) --> [].

verbo(Rs, Tiempo, Persona, Numero, Lprep, Raiz) -->
                            [V],
                            { name(V, Vs),
                              append(Rs, Ts, Vs),
                              name(Raiz, Rs),
                              es_raiz(Raiz, Lprep),
                              name(Termin, Ts),
                              es_terminacion(Termin, Tiempo, Persona, Numero)}.

% Complemento
complemento(GN, _) --> gn(GN, _, _, _).
% Complemento circustancial
complemento([P|GN], [P]) --> [P], { es_preposicion(P)}, gn(GN, _, _, _).
complemento([_], _) --> [_].



% Salida
componer(Salida, SUJ, CI, Verb, SujS, VerbS, CDs, P, N, Tiempo, Modo, Preg, C):-
% Primera parte puesta
append(SUJ, CI, Aux1),
name(V, Verb),
verbo_modo(Tv, Tpv, Tpp, V),
name(Tv, Tvname),
append(Verb, Tvname, Va),
name(Vr, Va),
append(Aux1, [Vr], Aux2),
% Principio modo
principiomodo(Ini, Modo),
append(Aux2, [Ini], Aux3),
% Introduce pregunta
principiopregunta(IniP, Preg, V),
append(Aux3, IniP, Aux4),
% Sujero de la subordinada
append(Aux4, SujS, Aux5),
% Verbo subordinada
verbo_modo(Terminacion, Tiempo, P, VerbS),
name(Terminacion, Tname),
name(VerbS, VSname),
append(VSname, Tname, Mezcla),
name(Mname, Mezcla),
append(Aux5, [Mname], Aux6),
% CDs y Cs
append(Aux6, CDs, Aux7),
append(Aux7, C, Aux8),
% Cerramos pregunta
finalpregunta(FinP, Preg),
append(Aux8, FinP, Aux9),
% Cerramos comillas
finalmodo(Fin, Modo),
append(Aux9, Fin, Salida).




% Crea el inicio de la subordinada
% Si la original era indirecta
principiomodo(dospuntosYcomillas, que).
% Si la original era directa
principiomodo(que, []).

% Crea el final de la suborninada
% Si la original es indirecta
finalmodo([comillas], que).
% Si la original era directa
finalmodo([], []).

% Crea el inicio de la pregunta
% Si la original era indirecta
principiopregunta([interroganteabierto], si, pregunt).
% Si la original era directa
principiopregunta([si], [], pregunt).
principiopregunta([], _, _).

% Crea el final de la pregunta
% Si la original es indirecta
finalpregunta([interrogantecerrado], si).
% Si la original era directa
finalpregunta([], []).


% Nombres propios
es_nombre_p(maria, fem).
es_nombre_p(juan, masc).
es_nombre_p(miguel, masc).
es_nombre_p(lucia, fem).
es_nombre_p(luis, masc).

% Sustantivos
es_nombre(amigo, singular, masc).
es_nombre(cambio, singular, masc).
es_nombre(vida, singular, fem).
es_nombre(noche, singular, fem).
% EXCEPCIONES: A pesar de ser un adjetivo lo trato como nombre
%  para mayor facilidad en la implementacion.
es_nombre(contento, singular, masc).
es_nombre(ocupada, singular, fem).

% Determinantes
% Devuelvo el ultimo parametro mas arriba (o eso creo, luego lo intercambio)
es_art(un, singular, masc, un).
es_art(mi, singular, masc, su).
es_art(mi, singular, fem, su).
es_art(su, singular, masc, mi).
es_art(su, singular, fem, mi).
es_art(esa, singular, fem, esta).
es_art(esta, singular, fem, esa).
es_pronombre(me, 3, singular, me).
% EXCEPCIONES: A pesar de no ser pronombres (son formas verbales no personales), los 
% introduzco aqui para mayor facilidad en la implementacion.
es_pronombre(verte, 3, singular, verme).
es_pronombre(verme, 3, singular, verte).


% Conseguir la terminacion contraria
verbo_modo(s, pasado, 3, e).
verbo_modo(ra, presente, 3, e).
verbo_modo(oy, pasado, 1, est).
verbo_modo(as, pasado, 1, est).
verbo_modo(aba, presente, 1, est).
verbo_modo(aba, presente, 2, est).
verbo_modo(o, pasado, 1, necesit).
verbo_modo(aba, presente, 1, necesit).
verbo_modo(ijo, _, _, d).
verbo_modo(o, _, _, pregunt).

% Raices de verbo
es_raiz(e, []).
es_raiz(est, []).
es_raiz(necesit, []).
es_raiz(d, []).
es_raiz(pregunt, []).

% Preposiciones
es_preposicion(en).
es_preposicion(de).

% Fonemas de tiempo verbal
% dijo
es_terminacion(ijo, pasado, 3, singular).
% pregunto
es_terminacion(o, pasado, 3, singular).
% es
es_terminacion(s, presente, 3, singular).
% era
es_terminacion(ra, pasado, 3, singular).
% estoy
es_terminacion(oy, presente, 1, singular).
% estaba
es_terminacion(aba, pasado, 3, singular).
% necesito
es_terminacion(o, presente, 1, singular).
% necesitaba
es_terminacion(aba, pasado, 1, singular).
% estas
es_terminacion(as, presente, 2, singular).

% Para saber el modo y si hay pregunta
es_indirecto(que).
hay_pregunta(si).


% gramática
consulta:- write('Escribe frase entre corchetes separando palabras con comas '), nl,
write('o lista vacia para parar '), nl,
read(F),
trata(F).
trata([]):- write('final').
% tratamiento final
trata(F):- frase(Salida, F, []), write(Salida), consulta.
% tratamiento caso general

/*
?- frase(Salida, [maria, me, dijo, juan, es, mi, amigo], []).

Salida = [maria, me, dijo, que, juan, era, su, amigo] ;

No
*/


/*
Estilo directo: María me dijo: “Juan es mi amigo”
Estilo indirecto: María me dijo que Juan era su amigo
Estilo directo: Miguel me dijo: “Estoy contento de verte”
Estilo indirecto: Miguel me dijo que estaba contento de verme
Estilo directo: Lucía me dijo: “Necesito un cambio en mi vida”
Estilo indirecto: Lucía me dijo que necesitaba un cambio en su vida
Estilo directo: Luis me preguntó: “¿Estás ocupada esta noche?”
Estilo indirecto: Luis me preguntó que si estaba ocupada esa noche
*/
