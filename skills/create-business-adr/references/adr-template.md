# Plantilla de ADR con respaldo empresarial

Adaptar los encabezados, estado, idioma, metadatos y nombre de archivo a las convenciones del repositorio. Eliminar los apartados opcionales vacíos. Sustituir todos los textos entre corchetes antes de entregar.

```markdown
# ADR-[NNN]: [Verbo de decisión] [alcance] [resultado buscado]

## Estado

[Draft | Propuesto | Aceptado | Rechazado | Reemplazado por ADR-XXX]

**Autores:** [nombre, rol]  
**Fecha:** [YYYY-MM-DD]
[**Decisor o responsable:** [rol o equipo]]
[**Revisión:** [fecha, condición o métrica que obliga a revisar]]

---

## Contexto

[Describir la situación actual, el problema, el alcance afectado y por qué debe decidirse ahora. Separar hechos, restricciones y supuestos.]

### Impacto empresarial y criterios de decisión

- **Objetivo:** [valor que se pretende crear o proteger para clientes, operación, riesgo, coste, cumplimiento o continuidad].
- **Coste o riesgo de no actuar:** [qué empeora o se mantiene si se conserva el statu quo].
- **Criterios:** [los criterios que determinan la elección, ordenados si existe prioridad].
- **Evidencia y límites:** [datos, incidentes, investigación o contratos que lo respaldan; señalar las hipótesis].
- **Afectados:** [clientes, equipos, proveedores, operaciones o productos impactados].

### Alternativas consideradas

- **[Alternativa elegida].** [Por qué satisface mejor los criterios ahora.]
- **[Alternativa 1].** [Por qué se descarta, pospone o limita.]
- **[Statu quo / no cambiar].** [Por qué no resulta aceptable o por qué se conserva parcialmente.]

## Decisión

[El producto, sistema o equipo utilizará/no utilizará/deberá/no deberá X para conseguir Y.]

### [Regla o frontera principal]

[Definir el comportamiento, contrato, propiedad, dependencia o invariante que será obligatorio.]

### [Responsabilidades y límites]

[Indicar quién decide, ejecuta u opera; especificar qué queda fuera de alcance.]

### [Migración, compatibilidad o rollout, si aplica]

[Definir condiciones de adopción o coexistencia. Mantener el detalle de tareas en el plan de implementación.]

---

## Consecuencias

### Positivas

- **[Beneficio].** [Quién se beneficia, cómo se espera obtenerlo y señal o control que permitirá comprobarlo.]
- **[Reducción de riesgo o coste].** [Mecanismo causal y evidencia o hipótesis.]

### Negativas

- **[Coste, riesgo o limitación].** [Quién lo asume y mitigación, límite o responsable.]
- **[Dependencia, complejidad o deuda].** [Cómo se operará y qué indicaría que debe revisarse.]

## Trade-offs

Se acepta [coste, limitación o riesgo concreto] a cambio de [beneficio priorizado].

[Revisar esta decisión si ocurre [condición, escala, fecha, métrica o cambio de contexto].]
```

## Señales de una redacción sólida

- El título y el primer párrafo de `Decisión` comunican el mismo compromiso concreto.
- El contexto explica tanto la necesidad técnica como el motivo empresarial de decidir ahora.
- Las alternativas son opciones que realmente podrían haberse elegido; el statu quo aparece cuando es relevante.
- Cada consecuencia negativa tiene un coste, dueño, límite o mitigación reconocible.
- Los beneficios inciertos se presentan como hipótesis y tienen una forma de validación.
- Los trade-offs dicen qué se sacrifica y por qué el sacrificio es aceptable.
