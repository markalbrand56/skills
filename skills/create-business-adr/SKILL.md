---
name: create-business-adr
description: Crear o revisar Architecture Decision Records (ADRs) que conviertan una propuesta o decisión técnica, operativa o de plataforma en un registro claro, trazable y con respaldo empresarial. Usar al redactar, formalizar, mejorar o revisar un ADR; documentar una decisión arquitectónica significativa; comparar alternativas; explicar beneficios, costes, riesgos, responsables o criterios de éxito; o adaptar un ADR a las convenciones de un repositorio.
---

# Crear ADR con respaldo empresarial

Convertir una decisión significativa en un registro que permita entender qué se decidió, por qué importa, qué se sacrifica y cómo se revisará. Mantener el ADR breve en su tesis y preciso en sus consecuencias; usar la profundidad necesaria para que sea accionable, no para repetir documentación de implementación.

## Descubrir las convenciones y el alcance

1. Inspeccionar primero los ADRs existentes, la documentación arquitectónica relacionada y las decisiones que dependan de la nueva. Adoptar su idioma, numeración, estado, metadatos, nombres de archivo y profundidad.
2. Confirmar que la propuesta sea una decisión arquitectónicamente significativa: afecta límites, dependencias, seguridad, fiabilidad, cumplimiento, costes, operación, datos, escalabilidad o una elección difícil de revertir. Si es un detalle local o una tarea de implementación, recomendar el artefacto más ligero en lugar de crear un ADR.
3. Delimitar una sola decisión. Separar decisiones que puedan aceptarse, revertirse o evolucionar independientemente; conservar juntas solo las reglas inseparables de la misma decisión.
4. Leer los ADRs que la propuesta amplía, contradice o reemplaza. No cambiar una decisión previa silenciosamente: enlazarla y usar el estado de sustitución que emplee el repositorio.

## Preparar el expediente de decisión

Antes de redactar, reunir hechos comprobables y distinguirlos de hipótesis. Obtener o pedir solo la información que falte para decidir:

- problema actual, su urgencia y las personas, equipos o clientes afectados;
- resultado empresarial buscado y coste o riesgo de mantener el statu quo;
- restricciones no negociables: presupuesto, plazo, regulación, seguridad, SLA, compatibilidad, capacidad u operación;
- alternativas viables, incluida la opción de no cambiar, y por qué no se eligen;
- decisión propuesta, límites explícitos y responsables de aprobarla o ejecutarla;
- efectos esperados, costes asumidos, riesgos, mitigaciones y señales para comprobar o revisar la decisión.

No inventar aprobaciones, métricas, ahorros, fechas, incidentes ni requisitos. Identificar como hipótesis cualquier beneficio que aún no tenga evidencia, y proponer cómo validarlo. Omitir información confidencial, secretos, datos personales y detalles que pertenezcan a otro documento.

## Redactar el ADR

Usar [la plantilla](references/adr-template.md) y conservar la estructura del repositorio si esta difiere. Mantener como mínimo `Estado`, `Contexto`, `Decisión`, `Consecuencias` con apartados positivos y negativos, y `Trade-offs` cuando sea el formato adoptado.

### Estado y título

- Escribir un título que exprese la decisión con un verbo: «Adoptar», «Mantener», «Separar», «Desacoplar» o equivalente. Evitar títulos de tarea como «Investigar X».
- Respetar el vocabulario de estados del repositorio. Si no existe, usar `Draft` mientras se edita, `Propuesto` para solicitar aprobación, `Aceptado` cuando se adopta, `Rechazado` si se decide no proceder y `Reemplazado por ADR-XXX` cuando una decisión posterior la sustituye.
- Incluir autoría y fecha según la convención existente. Añadir decisor, responsables o condición de revisión solo cuando sean conocidos y aporten trazabilidad real.

### Contexto

Explicar la situación anterior, el problema y las fuerzas que obligan a decidir. Separar antecedentes de la solución elegida. Incluir, cuando sea material, un subapartado de impacto empresarial que conecte la decisión con:

- valor para cliente, operación, riesgo, coste, velocidad de entrega, cumplimiento o continuidad;
- coste y riesgo de no actuar;
- criterios que gobernaron la elección y evidencia disponible;
- afectados y dependencias relevantes.

Describir las alternativas evaluadas en el contexto cuando esto ayude a entender la decisión. Compararlas contra los criterios reales y explicar por qué la opción elegida es preferible ahora; no presentar una alternativa débil como si fuera una evaluación seria.

### Decisión

Abrir con una frase inequívoca que pueda leerse aislada: el sistema, equipo o producto «utilizará», «no utilizará», «deberá» o «no deberá» hacer algo. Desarrollar después las reglas, fronteras, invariantes, responsabilidades y exclusiones que hagan verificable la decisión.

Precisar qué queda dentro y fuera de alcance. Diferenciar la decisión estable de los pasos de implementación que pueden cambiar. Enlazar ADRs, contratos, estándares o evidencia relacionada mediante rutas relativas cuando existan.

### Consecuencias y trade-offs

Documentar efectos causales, no adjetivos genéricos. Para cada consecuencia importante, identificar quién se beneficia o asume el coste, qué cambia en la operación o el producto, y cómo se mitigará o verificará si procede.

- En `Positivas`, expresar beneficios esperados sin prometer resultados no comprobados. Asociar cada hipótesis relevante con una señal, métrica, prueba o revisión.
- En `Negativas`, declarar dependencias nuevas, complejidad, costes recurrentes, riesgos de migración, pérdida de flexibilidad, entrenamiento, soporte y deuda deliberada. No esconderlos como detalles de implementación.
- En `Trade-offs`, declarar explícitamente el coste aceptado a cambio del valor priorizado: «Se acepta X para obtener Y». Añadir condiciones de revisión cuando un supuesto, métrica, fecha o cambio de escala pudiera invalidar la decisión.

## Comprobar antes de entregar

Verificar que el ADR permita a una persona técnica y a una responsable de negocio responder, sin reunión adicional:

1. ¿Qué decisión concreta se tomó y cuál es su límite?
2. ¿Qué problema, oportunidad o riesgo empresarial la justifica ahora?
3. ¿Qué alternativas y statu quo se consideraron, y por qué no se eligieron?
4. ¿Qué beneficios, costes, riesgos y dependencias se aceptan?
5. ¿Quién queda afectado, qué evidencia sustenta la decisión y cuándo debe revisarse?

Corroborar también que el documento use el número y estado correctos, no contradiga ADRs vigentes, enlace las decisiones relacionadas, diferencie hechos de estimaciones y no incluya contenido sin fuente. Si la decisión modifica comportamiento de software, proponer las pruebas, métricas o controles operativos que deberán cambiar, pero no afirmar que ya existen sin verificarlo.

