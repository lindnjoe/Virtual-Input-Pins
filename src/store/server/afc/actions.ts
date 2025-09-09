import { ActionTree } from 'vuex'
import { AFCState, Lane } from './types'

let fetchInterval: ReturnType<typeof setInterval> | null = null

export const actions: ActionTree<AFCState, any> = {
  startAFCDataFetchInterval({ dispatch }) {
    if (fetchInterval) return
    dispatch('fetchAFCData')
    fetchInterval = setInterval(() => dispatch('fetchAFCData'), 5000)
  },

  stopAFCDataFetchInterval() {
    if (fetchInterval) {
      clearInterval(fetchInterval)
      fetchInterval = null
    }
  },

  fetchAFCData({ commit, rootState }) {
    const printer = rootState?.printer ?? {}
    const afc = printer['AFC'] ?? {}
    const lanes: Lane[] = []
    const laneList: string[] = []
    const mapList: string[] = []

    if (Array.isArray(afc.lanes)) {
      afc.lanes.forEach((name: string) => {
        const laneData = printer[`AFC_stepper ${name}`] || {}
        lanes.push({
          name,
          map: laneData.map || '',
          tool_loaded: laneData.tool_loaded || false,
        })
        laneList.push(name)
        if (laneData.map) mapList.push(laneData.map)
      })
    }

    commit('setLanes', lanes)
    commit('setLaneList', laneList)
    commit('setMapList', mapList)
  },

  reset({ commit }) {
    commit('reset')
  },
}
