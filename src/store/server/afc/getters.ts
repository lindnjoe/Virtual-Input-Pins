import { GetterTree } from 'vuex'
import { AFCState } from './types'

export const getters: GetterTree<AFCState, any> = {
  lanes: (state) => state.lanes,
  laneList: (state) => state.laneList,
  mapList: (state) => state.mapList,
}
