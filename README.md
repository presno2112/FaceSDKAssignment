# FaceSDKAssignment

Aplicación simple en SwiftUI para capturar un rostro usando [Regula FaceSDK]([https://regulaforensics.com/products/biometrics/facesdk/](https://docs.regulaforensics.com/develop/face-sdk/mobile/getting-started/installation/ios/)), seleccionar una imagen desde la galería y comparar la similitud entre ambas imágenes.

## Descripción de la solución

Esta app implementa un flujo básico de comparación facial:

1. Captura una imagen facial usando el SDK de Regula.
2. Permite seleccionar una imagen desde la galería.
3. Compara la similitud entre ambas imágenes utilizando el SDK.
4. Muestra el porcentaje de similitud.
5. Permite reiniciar el proceso.

Es importante mencionar que la aplicación no le permite al usuario avanzar hasta que complete el paso anterior.  

Se usó SwiftUI como base para la UI y se encapsuló la lógica del SDK en un objeto observable dedicado para mantener una separación clara entre vistas y lógica de negocio.

## Patrones utilizados

- **Arquitectura VOODO**: La vista principal (`MainView`) se comunica con una clase observable (`FaceOO`) que contiene la lógica y el estado. De esta forma se asegura que la vista pueda acceder solamente a las propiedades justas del SDK y da paso a **escalabilidad**.
- **Combine para inicialización reactiva**: Se utiliza `Combine` para inicializar el SDK de manera asincrónica y manejar errores de forma clara.
- **@State y @Binding**: Para manejar el estado de la UI de forma dinámica.
- **Encapsulamiento del SDK**: Toda interacción con el FaceSDK está centralizada en el observable `FaceOO`.

## Decisiones técnicas

- La inicialización del SDK se maneja como un `Publisher`, lo que mejora la escalabilidad del código.
- La UI desactiva los botones de forma contextual para guiar al usuario en el flujo correcto.
- El flujo de comparación facial solo se habilita cuando ambas imágenes están presentes.
- La lógica para `LivenessDetection` está disponible pero no se incluyó en el flujo principal, dejando espacio para futuras mejoras.

## Mejoras posibles

- Mostrar feedback visual en caso de errores (por ejemplo, si falla la carga de la imagen).
- Implementación de pruebas unitarias para `FaceOO`.
- Agregar soporte completo para (`LivenessDetection`) en el flujo principal.
- Almacenar resultados previos o historial de comparaciones, incluso alguna funcionalidad dependiente del resultado de la comparación.
- Pulir la interfaz visual con animaciones o mejoras de diseño.



## Requisitos

- Xcode 15 o superior
- iOS 15+
- SDK de Regula FaceSDK configurado (instrucciones en la [documentación oficial](https://docs.regulaforensics.com/develop/face-sdk/))

## Autor

Sebastián Presno Alvarado

---

> Este proyecto fue desarrollado como parte de un proceso de entrevista técnica para React. El objetivo fue demostrar la integración del SDK, la aplicación de buenas prácticas de desarrollo y la creación de una solución funcional y mantenible.


