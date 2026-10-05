<script setup lang="ts">
const props = defineProps<{
  message: string;
}>();
</script>

<template>
  <div>{{ message }}</div>
</template>
