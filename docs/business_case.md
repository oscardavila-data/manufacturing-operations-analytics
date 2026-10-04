# Business Case — Manufacturing Operations & Demand Planning Analytics

**Empresa:** NovaTech Electronics (ficticia)  
**Ubicación:** Guadalajara, Jalisco, México  
**Industria:** Electronics Manufacturing Services (EMS)  
**Proyecto:** Manufacturing Operations & Demand Planning Analytics

---

## 📌 Nota importante

NovaTech Electronics es una **empresa ficticia**. Los datos son **sintéticos** y fueron diseñados para representar problemas operativos reales. No representan a Flex, Jabil, PiSA ni a ninguna empresa real.

---

## 🏢 Contexto de la empresa

NovaTech Electronics es una empresa de manufactura electrónica que fabrica componentes para clientes industriales, automotrices, médicos y de consumo.

Su modelo de negocio es similar al de una empresa de **contract manufacturing / EMS**: recibe pedidos y pronósticos de demanda de sus clientes, compra componentes a proveedores, mantiene inventario y utiliza varias líneas de producción para fabricar el producto terminado.

### Flujo operativo

Demanda del cliente → Planeación de demanda → Inventario y disponibilidad de materiales → Compras → Entrega de proveedores → Producción → Producto terminado → Cumplimiento del pedido

Una falla en cualquier parte de la cadena afecta al resto. Por ejemplo:

- Aumenta la demanda de un producto.
- El inventario de componentes no es suficiente.
- Se genera una orden de compra.
- El proveedor se retrasa.
- Producción no puede fabricar a tiempo.
- Se retrasa el pedido del cliente.

---

## ⚠️ La situación empresarial

Durante los últimos meses, NovaTech ha experimentado una creciente dificultad para mantener un equilibrio entre:

- Demanda de clientes.
- Inventario.
- Abastecimiento.
- Capacidad de producción.

### Síntomas observados

- Algunos productos tienen inventario insuficiente.
- Otros mantienen inventario elevado durante largos períodos.
- Determinadas órdenes de compra llegan tarde.
- Algunos materiales tienen tiempos de abastecimiento elevados.
- Ciertas órdenes de producción no alcanzan lo planificado.
- La demanda de algunos productos está aumentando.
- El equipo de planificación usa información de diferentes fuentes y no tiene una vista consolidada del riesgo.

### El problema real

> La dirección sabe que existen problemas, pero no tiene una forma suficientemente rápida de identificar cuáles requieren atención primero.

---

## 🎯 El problema que recibe el Data Analyst

> **Management needs to identify which products and supply situations pose the greatest risk to customer fulfillment, understand the operational drivers behind that risk, and determine where planning efforts should be prioritized.**

En español:

> La dirección necesita identificar qué productos y situaciones de abastecimiento representan el mayor riesgo para cumplir la demanda de los clientes, entender qué factores operativos están contribuyendo a ese riesgo y determinar dónde debe concentrarse el equipo de planificación.

---

## 👥 Stakeholders

El análisis está dirigido a varios perfiles dentro de la organización:

| Stakeholder | Qué necesita |
| :--- | :--- |
| **Operations Manager** | Saber dónde existen problemas de cumplimiento. |
| **Demand Planner** | Anticipar cambios en la demanda y saber qué productos requieren atención. |
| **Supply / Materials Planner** | Identificar materiales y órdenes de compra que podrían provocar faltantes. |
| **Procurement** | Detectar proveedores con problemas de lead time o cumplimiento. |
| **Plant / Production Manager** | Saber dónde producción está quedando por debajo del plan. |
| **Management** | Vista ejecutiva de los principales riesgos y prioridades. |

---

## ❓ La decisión principal

Todo el proyecto debe ayudar a responder:

> **¿Qué debemos priorizar para proteger el cumplimiento de la demanda de nuestros clientes?**

No significa necesariamente "comprar más". Podría significar:

- Acelerar una orden de compra.
- Revisar un proveedor.
- Priorizar producción de determinado producto.
- Reasignar inventario.
- Revisar un forecast.
- Investigar una caída de producción.
- Evitar seguir acumulando inventario de otro producto.

---

## ⚖️ La tensión empresarial

La empresa no quiere simplemente "tener más inventario", porque el inventario excesivo también cuesta dinero.

| Muy poco inventario | Demasiado inventario |
| :--- | :--- |
| Riesgo de stockout | Capital inmovilizado |
| Incumplimiento | Baja rotación |
| Retrasos al cliente | Riesgo de exceso |

**El objetivo no es maximizar inventario, sino mantener suficiente cobertura para atender la demanda sin acumular inventario innecesario.**

---

## 📋 Preguntas de negocio

El proyecto responde 15 preguntas agrupadas en 5 bloques.

### Bloque A — Demanda

| ID | Pregunta |
| :--- | :--- |
| Q1 | ¿Cómo está evolucionando la demanda? |
| Q2 | ¿Qué productos presentan crecimiento que pueda generar presión sobre el suministro? |
| Q3 | ¿Qué productos deberían recibir mayor atención en el próximo horizonte? |

### Bloque B — Inventario

| ID | Pregunta |
| :--- | :--- |
| Q4 | ¿Qué productos tienen suficiente inventario para cubrir su demanda esperada? |
| Q5 | ¿Qué productos presentan riesgo de stockout? |
| Q6 | ¿Dónde existe exceso de inventario? |

### Bloque C — Abastecimiento

| ID | Pregunta |
| :--- | :--- |
| Q7 | ¿Qué proveedores presentan peor desempeño de entrega? |
| Q8 | ¿Qué productos dependen de proveedores de alto riesgo? |
| Q9 | ¿Qué órdenes de compra podrían afectar productos críticos? |

### Bloque D — Producción

| ID | Pregunta |
| :--- | :--- |
| Q10 | ¿Qué productos tienen mayor brecha entre producción planificada y real? |
| Q11 | ¿Qué plantas o líneas tienen peor desempeño? |
| Q12 | ¿Qué productos combinan problemas de demanda, inventario y producción? |

### Bloque E — Priorización

| ID | Pregunta |
| :--- | :--- |
| Q13 | ¿Cuáles son las situaciones de mayor riesgo para cumplir la demanda? |
| Q14 | ¿Qué factores aparecen asociados a los productos de alto riesgo? |
| Q15 | ¿Dónde debería concentrarse primero el equipo de Planning? |

---

## 🎯 La pregunta maestra

Todas las preguntas convergen en una sola:

> **¿Dónde está el mayor riesgo operativo, por qué está ocurriendo y qué debería priorizar el equipo de planeación?**

---

## 📦 Alcance del proyecto

### Incluye

- Demanda.
- Inventario.
- Compras.
- Proveedores.
- Producción.
- Planeación.

### No incluye (en esta versión)

- Recursos Humanos.
- Finanzas corporativas completas.
- Customer Service.
- CRM.
- Calidad de manufactura completa.
- IoT.
- MES.
- Machine Learning.
- APIs externas.

No porque no sean interesantes, sino porque no son necesarios para responder el business case.

---

## 📊 Entregable esperado

El análisis debe producir una **lista priorizada de productos y situaciones de riesgo**, con:

| Elemento | Descripción |
| :--- | :--- |
| **Producto** | Código y nombre |
| **Tendencia de demanda** | Creciente, estable o decreciente |
| **Cobertura de inventario** | Meses de cobertura |
| **Riesgo de proveedor** | Lead time y tasa de retraso |
| **Brecha de producción** | Diferencia entre planeado y real |
| **Riesgo consolidado** | Score de 0 a 6 |

Y una **recomendación accionable** para cada caso.

---

## 🔄 Ciclo de negocio simulado

El proyecto simula un proceso de planning / S&OP / supply review:

1. ¿Cuánta demanda esperamos?
2. ¿Cuánto inventario tenemos?
3. ¿Tenemos materiales suficientes?
4. ¿Los proveedores están cumpliendo?
5. ¿Podemos producir lo necesario?
6. ¿Qué pedidos o productos están en riesgo?
7. ¿Qué debemos priorizar?

---

## 📐 Regla fundamental

Cada visualización del dashboard debe poder responder:

> **¿Qué decisión permite tomar?**

Si no se puede responder eso, el visual sobra.

---

## 🧭 Cómo se conecta con el resto del proyecto

| Fase | Documento |
| :--- | :--- |
| Business Case | Este documento |
| Data Dictionary | [`data_dictionary.md`](data_dictionary.md) |
| SQL | [`../sql/`](../sql/) |
| DAX | [`../dax/measures.dax`](../dax/measures.dax) |
| Dashboard | [`../README.md`](../README.md) |

---

> **Nota:** NovaTech Electronics es una empresa ficticia. Los datos son sintéticos y fueron diseñados para representar problemas operativos reales. No representan a ninguna empresa real.