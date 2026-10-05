<script setup lang="ts">
import CustomComponent from './CustomComponent.vue';


console.log('file.vue');

</script>

<template>
  <div>
    <h1>File Component</h1>
    <p>This is a simple Vue component.</p>
    <CustomComponent message="Hello from file.vue!" />
  </div>
</template>
