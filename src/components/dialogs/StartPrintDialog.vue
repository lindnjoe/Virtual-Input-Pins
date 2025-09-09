<template>
  <v-dialog
    v-model="bool"
    :max-width="400"
    content-class="overflow-x-hidden"
    @click:outside="closeDialog"
    @keydown.esc="closeDialog"
  >
    <v-card>
      <div
        v-if="bigThumbnailUrl"
        class="d-flex align-center justify-center"
        style="min-height:200px"
      >
        <v-img
          :src="bigThumbnailUrl"
          :max-width="maxThumbnailWidth"
          class="d-inline-block"
          :style="bigThumbnailStyle"
        />
      </div>

      <v-card-title class="text-h5">
        {{ $t('Dialogs.StartPrint.Headline') }}
      </v-card-title>

      <v-card-text class="pb-0">
        <p class="body-2">{{ question }}</p>
      </v-card-text>

      <!-- AFC filament mapping -->
      <start-print-dialog-afc
        v-if="afcEnabled"
        :file="file"
        @tool-count="validateToolCount"
      />
      <!-- Spoolman fallback -->
      <start-print-dialog-spoolman
        v-else-if="moonrakerComponents.includes('spoolman')"
        :file="file"
      />

      <template v-if="moonrakerComponents.includes('timelapse')">
        <v-divider
          v-if="!moonrakerComponents.includes('spoolman') || !afcEnabled"
          class="mt-3 mb-2"
        />
        <v-card-text class="py-0">
          <settings-row :title="$t('Dialogs.StartPrint.Timelapse')">
            <v-switch v-model="timelapseEnabled" hide-details class="mt-0" />
          </settings-row>
        </v-card-text>
        <v-divider class="mt-2 mb-0" />
      </template>

      <v-card-actions>
        <v-spacer />
        <v-btn text @click="closeDialog">
          {{ $t('Dialogs.StartPrint.Cancel') }}
        </v-btn>
        <v-btn
          color="primary"
          text
          :disabled="printerIsPrinting || !klipperReadyForGui || !validToolCount"
          @click="startPrint(file.filename)"
        >
          {{ $t('Dialogs.StartPrint.Print') }}
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script lang="ts">
import { Component, Mixins, Prop } from 'vue-property-decorator'
import BaseMixin from '@/components/mixins/base'
import SettingsRow from '@/components/settings/SettingsRow.vue'
import StartPrintDialogAfc from '@/components/dialogs/StartPrintDialogAfc.vue'


import StartPrintDialogSpoolman from '@/components/dialogs/StartPrintDialogSpoolman.vue'

import { FileStateGcodefile } from '@/store/files/types'
import { ServerSpoolmanStateSpool } from '@/store/server/spoolman/types'
import { mdiPrinter3d } from '@mdi/js'
import { defaultBigThumbnailBackground, thumbnailBigMin } from '@/store/variables'

@Component({



  components: { SettingsRow, StartPrintDialogAfc, StartPrintDialogSpoolman },

  components: { SettingsRow, StartPrintDialogAfc },


})
export default class StartPrintDialog extends Mixins(BaseMixin) {
  mdiPrinter3d = mdiPrinter3d
  validToolCount = true

  @Prop({ required: true, default: false }) readonly bool!: boolean
  @Prop({ required: true, default: '' }) readonly currentPath!: string
  @Prop({ required: true }) file!: FileStateGcodefile

  get timelapseEnabled() {
    return this.$store.state.server.timelapse?.settings?.enabled ?? false
  }
  set timelapseEnabled(val: boolean) {
    this.$socket.emit(
      'machine.timelapse.post_settings',
      { enabled: val },
      { action: 'server/timelapse/initSettings' }
    )
  }

  get afcEnabled() {
    return 'AFC' in this.$store.state.printer
  }

  get bigThumbnailBackground() {
    return (
      this.$store.state.gui.uiSettings.bigThumbnailBackground ??
      defaultBigThumbnailBackground
    )
  }
  get bigThumbnailStyle() {
    return defaultBigThumbnailBackground.toLowerCase() ===
      this.bigThumbnailBackground.toLowerCase()
      ? {}
      : { backgroundColor: this.bigThumbnailBackground }
  }

  get active_spool(): ServerSpoolmanStateSpool | null {
    return this.$store.state.server.spoolman?.active_spool ?? null
  }
  get filamentVendor() {
    return this.active_spool?.filament?.vendor?.name ?? 'Unknown'
  }
  get filamentName() {
    return this.active_spool?.filament.name ?? 'Unknown'
  }
  get filament() {
    return `${this.filamentVendor} - ${this.filamentName}`
  }

  get question() {
    if (this.active_spool) {
      return this.$t('Dialogs.StartPrint.DoYouWantToStartFilenameFilament', {
        filename: this.file?.filename ?? 'unknown',
      })
    }
    return this.$t('Dialogs.StartPrint.DoYouWantToStartFilename', {
      filename: this.file?.filename ?? 'unknown',
    })
  }

  get fileTimestamp() {
    return typeof this.file.modified.getTime === 'function'
      ? this.file.modified.getTime()
      : 0
  }
  get thumbnails() {
    return this.file.thumbnails ?? []
  }
  get bigThumbnail() {
    return this.thumbnails.find(
      (thumb) => thumb.width >= thumbnailBigMin
    )
  }
  get currentPathWithoutSlash() {
    return this.currentPath.startsWith('/')
      ? this.currentPath.substring(1)
      : this.currentPath
  }
  get bigThumbnailUrl() {
    if (!this.bigThumbnail || !('relative_path' in this.bigThumbnail)) return null
    const base = [
      this.apiUrl,
      'server/files/gcodes',
      this.currentPathWithoutSlash,
      this.bigThumbnail.relative_path,
    ].filter(Boolean)
    return `${base.join('/')}?timestamp=${this.fileTimestamp}`
  }
  get maxThumbnailWidth() {
    return this.bigThumbnail?.width ?? 400
  }

  mounted() {
    if (this.afcEnabled) {
      this.$store.dispatch('server/afc/startAFCDataFetchInterval')
    }
  }

  startPrint(filename = '') {
    filename = (this.currentPath + '/' + filename).substring(1)
    this.closeDialog()
    this.$socket.emit('printer.print.start', { filename }, { action: 'switchToDashboard' })
  }

  validateToolCount(valid: boolean) {
    this.validToolCount = valid
  }

  closeDialog() {
    this.$emit('closeDialog')
  }
}
</script>

