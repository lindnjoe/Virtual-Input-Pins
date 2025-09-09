import { MutationTree } from 'vuex'
import { AFCState, Lane } from './types'

export const mutations: MutationTree<AFCState> = {
  setLanes(state, lanes: Lane[]) {
    state.lanes = lanes
  },
  setLaneList(state, laneList: string[]) {
    state.laneList = laneList
  },
  setMapList(state, mapList: string[]) {
    state.mapList = mapList
  },
  reset(state) {
    state.lanes = []
    state.laneList = []
    state.mapList = []
  },
}
