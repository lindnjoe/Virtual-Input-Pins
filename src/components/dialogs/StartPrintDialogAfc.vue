<template>
  <div class="afc-start-print-dialog">
    <afc-start-print :file="file" @tool-count="$emit('tool-count', $event)" />
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue } from 'vue-property-decorator'
import AfcStartPrint from '@/components/panels/Afc/AfcStartPrint.vue'
import { FileStateGcodefile } from '@/store/files/types'

@Component({
  components: { AfcStartPrint },
})
export default class StartPrintDialogAfc extends Vue {
  @Prop({ required: true }) file!: FileStateGcodefile
}
</script>

<style scoped>
.afc-start-print-dialog {
  margin-top: 8px;
}
</style>

