extensions [rnd gis csv]

breed [trabalhadores trabalhador]
breed [industrias industria]
breed [kibs-fires kibs-fire]
breed [atacados atacado]
breed [educacoes educacao]
breed [comercios-outros comercio-outros]

trabalhadores-own [classe utility priority move-state p hidden modo]
industrias-own [utility move-state hidden]
kibs-fires-own [utility move-state hidden]
atacados-own [utility move-state hidden]
educacoes-own [utility move-state hidden]
comercios-outros-own [utility move-state hidden]

patches-own [
  grid-code
  cell-type
  transit
  public-housing
  num-habitacoes-sociais
  roads
  railways
  trunks
  ;distance-to-cbd
  ;distance-to-roads
  ;distance-to-railways
  ;distance-to-trunks
  ;distance-to-transit
  ;dist-to-workplace
  dist-to-workplace_PuT
  dist-to-workplace_PrT

  dist-to-education-PuT-norm
  dist-to-education-PrT-norm
  dist-to-lazer-PuT-norm
  dist-to-lazer-PrT-norm
  dist-to-saude-PuT-norm
  dist-to-saude-PrT-norm

  status
  acc-put
  acc-prt
  iso-c1
  iso-c2
  iso-c3
  num-h1
  num-h2
  num-h3
  num-houses-per-cell
  num-workplaces-total
  num-workplaces-total-folga
  num-workplaces-comercial
  num-workplaces-industrial
  num-kibs-fire
  num-armazens
  num-atacados
  num-educacao
  num-outros-comercios

  total-trabalhadores
  total-trabalhadores-norm
  total-industrias
  total-industrias-norm
  total-industrias-vizinhanca
  total-educacoes
  total-educacoes-norm
  total-comercio
  total-comercio-outros
  total-comercio-outros-norm
  total-atacados
  total-atacados-norm
  total-kibs-fires
  total-kibs-fires-norm

  total-agentes-emprego-acc-put-60minutos
  total-agentes-emprego-acc-prt-60minutos

  num-escolas
  num-lazer
  num-saude
  num-ubs-postos
  num-hospitais

  acc-escolas-put-60minutos
  acc-escolas-prt-60minutos
  acc-lazer-put-60minutos
  acc-lazer-prt-60minutos
  acc-saude-put-60minutos
  acc-saude-prt-60minutos

  cidade-20-minutos-educacao
  cidade-20-minutos-lazer
  cidade-20-minutos-saude
  cidade-20-minutos-empregos
  cidade-20-minutos-total

  cid-20-minutos-educacao-norm
  cid-20-minutos-lazer-norm
  cid-20-minutos-saude-norm
  cid-20-minutos-empregos-norm
  cid-20-minutos-total-norm

  distancia-centro-rede
  distancia-ensino-superior-rede
  distancia-hospital-rede
  distancia-parque-rede
  distancia-acesso-rodovia-rede
  distancia-acesso-arterial-rede
  distancia-est-trem-rede
  distancia-est-metro-rede

  acrescimo-habitacoes
  acrescimo-empregos

  total-g1
  total-g2
  total-g3

]

globals [
  min-industrias
  max-industrias
  min-kibs-fires
  max-kibs-fires
  min-comercio-outros
  max-comercio-outros
  min-educacoes
  max-educacoes
  min-atacados
  max-atacados
  min-industrias-vizinhanca
  max-industrias-vizinhanca
  min-trabalhadores
  max-trabalhadores
  view-mode
  num-trabalhadores-by-class
  num-pessoas-por-classe
  sum-iso-c1
  sum-iso-c2
  sum-iso-c3
  sum-relative-iso-c1
  sum-relative-iso-c2
  sum-relative-iso-c3

  status-gini-index-reserve
  status-lorenz-points

  accessibility-gini-index-reserve-total
  accessibility-gini-index-reserve-c1
  accessibility-gini-index-reserve-c2
  accessibility-gini-index-reserve-c3

  accessibility-lorenz-points-total
  accessibility-lorenz-points-c1
  accessibility-lorenz-points-c2
  accessibility-lorenz-points-c3

  segregation-lorenz-points-c1
  segregation-lorenz-points-c2
  segregation-lorenz-points-c3
  segregation-gini-index-reserve-c1
  segregation-gini-index-reserve-c2
  segregation-gini-index-reserve-c3
  mean-utility
  mean-utility-total
  mean-utility-c1
  mean-utility-c2
  mean-utility-c3

  mean-utility-comercios-outros
  mean-utility-kibs-fires
  mean-utility-educacoes
  mean-utility-atacados
  mean-utility-industrias

  satisfaction-level-total
  satisfaction-level-c1
  satisfaction-level-c2
  satisfaction-level-c3

  moved-c1-list
  moved-c2-list
  moved-c3-list

  expelled-c1-list
  expelled-c2-list
  expelled-c3-list

  area-estudo
  grade

  roww
  patch-referencia

  lista-acc-empregos-trabalhadores-g1
  lista-acc-empregos-trabalhadores-g3

  lista-acc-lazer-trabalhadores-g1
  lista-acc-lazer-trabalhadores-g3

  lista-acc-educacao-trabalhadores-g1
  lista-acc-educacao-trabalhadores-g3

  lista-acc-saude-trabalhadores-g1
  lista-acc-saude-trabalhadores-g3

  matrix-tt-put-60minutos
  matrix-tt-prt-60minutos
  matrix-tt-walk-bicycle-put-10minutos

 ]

to setup
  clear-all
  ask patches
  [
    set public-housing false
    ;set distance-to-cbd distance patch 20 51
  ]

  setup-globals
  setup-city
  setup-trabalhadores-empregos
  setup-public-housing
  setup-acc

  setup-acc-agentes

  calc-statistics

  reset-ticks

end

to setup-globals
  set mean-utility (list 0 0 0 0)
  set mean-utility-total []
  set mean-utility-comercios-outros []
  set mean-utility-atacados []
  set mean-utility-educacoes []
  set mean-utility-kibs-fires []

  set mean-utility-industrias []
  set mean-utility-c1 []
  set mean-utility-c2 []
  set mean-utility-c3 []

  set satisfaction-level-total []
  set satisfaction-level-c1 []
  set satisfaction-level-c2 []
  set satisfaction-level-c3 []

end

to setup-city
  set area-estudo gis:load-dataset "Zonas_OD_SP.shp"
  set grade gis:load-dataset "rais_final_grade_v09_04_2024_UTM.shp"

  gis:apply-coverage grade "SP" cell-type
  gis:apply-coverage grade "OBJECTI" grid-code
  gis:apply-coverage grade "TRNST_1" transit
  gis:apply-coverage grade "RODOVIA" roads
  gis:apply-coverage grade "TREM" railways
  gis:apply-coverage grade "TRUNK" trunks
  gis:apply-coverage grade "TOT_ESCOLA" num-escolas
  gis:apply-coverage grade "TOT_LAZER" num-lazer
  gis:apply-coverage grade "TOT_UBS_PO" num-ubs-postos ;ubs, postos e centros de saude
  gis:apply-coverage grade "TOT_HOSP" num-hospitais ;numero de hospitais


  gis:set-world-envelope (gis:envelope-union-of (gis:envelope-of grade))

  ask patches with [cell-type = 1][
    ;set distance-to-roads calc-distance-to-roads self
    ;set distance-to-railways calc-distance-to-railways self
    ;set distance-to-trunks calc-distance-to-trunks self
    ;set distance-to-transit calc-distance-to-transit self
    set status calc-cell-status self]

end

to setup-trabalhadores-empregos
  gis:apply-coverage grade "G1_INT" num-h1
  gis:apply-coverage grade "G2_INT" num-h2
  gis:apply-coverage grade "G3_INT" num-h3
  gis:apply-coverage grade "ACC_CUM_PT" dist-to-workplace_PuT
  gis:apply-coverage grade "ACC_CUM_PR" dist-to-workplace_PrT
  gis:apply-coverage grade "ARMAZ_IND" num-workplaces-industrial
  gis:apply-coverage grade "KIBS_FIRE" num-kibs-fire
  gis:apply-coverage grade "ATACADO" num-atacados
  gis:apply-coverage grade "EDUCACAO" num-educacao
  gis:apply-coverage grade "OUTROS" num-outros-comercios

  ask patches with [cell-type = 1] [
    set num-houses-per-cell num-h1 + num-h2 + num-h3
    set num-kibs-fire round (num-kibs-fire / 100)
    set num-atacados round (num-atacados / 100)
    set num-educacao round (num-educacao / 100)
    set num-outros-comercios round (num-outros-comercios / 100)
    set num-workplaces-industrial round (num-workplaces-industrial / 100)
    set num-workplaces-total num-kibs-fire + num-atacados + num-educacao + num-outros-comercios + num-workplaces-industrial
    set num-workplaces-total-folga round (num-workplaces-total + (num-workplaces-total * 0.05))
  ]

  if Distrib-trab = "Real" [
    ask patches [sprout-trabalhadores num-h1 [set classe 1 set color blue set priority 3 set move-state "not-moved" set p random-float 1 if p > 0.352 [set modo 1] if p < 0.352 [set modo 0] set hidden false]]
    ask patches [sprout-trabalhadores num-h2 [set classe 2 set color yellow set priority 2 set move-state "not-moved" set p random-float 1 if p > 0.587 [set modo 1] if p < 0.587 [set modo 0] set hidden false]]
    ask patches [sprout-trabalhadores num-h3 [set classe 3 set color red set priority 1 set move-state "not-moved" set p random-float 1 if p > 0.772 [set modo 1] if p < 0.772 [set modo 0] set hidden false]]
    ask patches with [cell-type = 1] [sprout-comercios-outros num-outros-comercios [set color cyan]]
    ask patches with [cell-type = 1] [sprout-kibs-fires num-kibs-fire [set color magenta]]
    ask patches with [cell-type = 1] [sprout-atacados num-atacados [set color lime]]
    ask patches with [cell-type = 1] [sprout-educacoes num-educacao [set color violet]]
    ask patches with [cell-type = 1] [sprout-industrias num-workplaces-industrial [set color orange]]
  ]

  if Distrib-trab = "Aleatoria" [
    let probabilities (list 0.071 0.318 0.611)
    let classes (list 1 2 3)
    while [count trabalhadores < 17368]
        [let class-id first rnd:weighted-one-of-list (map list classes probabilities) last
          let candidate get-candidate-by-distribution class-id
          ;print candidate
          ask candidate [sprout-trabalhadores 1 [
            ;ht
            set classe class-id
            set hidden false
            set priority priority-of classe
            set move-state "not-moved"
            set p random-float 1
            if classe = 1 and p > 0.352 [set modo 1]
            if classe = 1 and p < 0.352 [set modo 0]
            if classe = 2 and p > 0.587 [set modo 1]
            if classe = 2 and p < 0.587 [set modo 0]
            if classe = 3 and p > 0.772 [set modo 1]
            if classe = 3 and p < 0.772 [set modo 0]
            ]
          ]
    ]

    while [count atacados < 1693]
    [let candidate-atacado get-candidate-by-distribution-atacado
      ask candidate-atacado [sprout-atacados 1 [
        ht
        set color lime]
      ]
    ]

    while [count educacoes < 1908]
    [let candidate-educacao get-candidate-by-distribution-educacao
      ask candidate-educacao [sprout-educacoes 1 [
        ht
        set color violet]
      ]
    ]

    while [count industrias < 2755]
    [let candidate-industria get-candidate-by-distribution-industrias
      ask candidate-industria [sprout-industrias 1 [
        ht
        set color orange]
      ]
    ]

    while [count kibs-fires < 5109]
    [let candidate-comercio get-candidate-by-distribution-kibs-fires
      ask candidate-comercio [sprout-kibs-fires 1 [
        ht
        set color magenta]
      ]
    ]

    while [count comercios-outros < 28486]
    [let candidate-comercio get-candidate-by-distribution-comercios
      ask candidate-comercio [sprout-comercios-outros 1 [
        ht
        set color cyan]
      ]
    ]
  ]

  set num-trabalhadores-by-class (list (count trabalhadores with [classe = 1]) (count trabalhadores with [classe = 2]) (count trabalhadores with [classe = 3]))
  ask patches with [count trabalhadores-here = 0 and num-workplaces-total = 0] [set cell-type 0]

end

to calc-statistics
  ;ask patches with [cell-type = 1][
  ask patches [
    set total-comercio count comercios-outros-here + count kibs-fires-here + count educacoes-here + count atacados-here
    set total-industrias count industrias-here
    set total-industrias-vizinhanca count industrias in-radius 4
    set total-trabalhadores count trabalhadores-here
    set total-educacoes count educacoes-here
    set total-comercio-outros count comercios-outros-here
    set total-atacados count atacados-here
    set total-kibs-fires count kibs-fires-here
    set total-g1 count trabalhadores-here with [classe = 1]
    set total-g2 count trabalhadores-here with [classe = 2]
    set total-g3 count trabalhadores-here with [classe = 3]
  ]

  set min-trabalhadores min [total-trabalhadores] of patches
  set max-trabalhadores max [total-trabalhadores] of patches
  set min-educacoes min [total-educacoes] of patches
  set max-educacoes max [total-educacoes] of patches
  set min-comercio-outros min [total-comercio-outros] of patches
  set max-comercio-outros max [total-comercio-outros] of patches
  set min-atacados min [total-atacados] of patches
  set max-atacados max [total-atacados] of patches
  set min-kibs-fires min [total-kibs-fires] of patches
  set max-kibs-fires max [total-kibs-fires] of patches
  set min-industrias min [total-industrias] of patches
  set max-industrias max [total-industrias] of patches

  ask patches [
    set total-trabalhadores-norm ([total-trabalhadores] of self - min-trabalhadores) / (max-trabalhadores - min-trabalhadores)
    set total-educacoes-norm ([total-educacoes] of self - min-educacoes) / (max-educacoes - min-educacoes)
    set total-comercio-outros-norm ([total-comercio-outros] of self - min-comercio-outros) / (max-comercio-outros - min-comercio-outros)
    set total-atacados-norm ([total-atacados] of self - min-atacados) / (max-atacados - min-atacados)
    set total-kibs-fires-norm ([total-kibs-fires] of self - min-kibs-fires) / (max-kibs-fires - min-kibs-fires)
    set total-industrias-norm ([total-industrias] of self - min-industrias) / (max-industrias - min-industrias)
    set status calc-cell-status self
  ]

  set min-industrias-vizinhanca min [total-industrias-vizinhanca] of patches
  set max-industrias-vizinhanca max [total-industrias-vizinhanca] of patches

  ask trabalhadores [set utility calc-utility classe patch-here p modo]
  ask comercios-outros [set utility calc-utility-comercios-outros patch-here]
  ask kibs-fires [set utility calc-utility-kibs-fires patch-here]
  ask atacados [set utility calc-utility-atacados patch-here]
  ask educacoes [set utility calc-utility-educacoes patch-here]
  ask industrias [set utility calc-utility-industrias patch-here]

  set lista-acc-empregos-trabalhadores-g1 (list 0)
  set lista-acc-empregos-trabalhadores-g3 (list 0)
  ask trabalhadores with [classe = 1] [ask patch-here [set lista-acc-empregos-trabalhadores-g1 lput [total-agentes-emprego-acc-prt-60minutos] of self lista-acc-empregos-trabalhadores-g1]]
  ask trabalhadores with [classe = 3] [ask patch-here [set lista-acc-empregos-trabalhadores-g3 lput [total-agentes-emprego-acc-prt-60minutos] of self lista-acc-empregos-trabalhadores-g3]]

  set lista-acc-lazer-trabalhadores-g1 (list 0)
  set lista-acc-lazer-trabalhadores-g3 (list 0)
  ask trabalhadores with [classe = 1] [ask patch-here [set lista-acc-lazer-trabalhadores-g1 lput [acc-lazer-prt-60minutos] of self lista-acc-lazer-trabalhadores-g1]]
  ask trabalhadores with [classe = 3] [ask patch-here [set lista-acc-lazer-trabalhadores-g3 lput [acc-lazer-prt-60minutos] of self lista-acc-lazer-trabalhadores-g3]]

  set lista-acc-educacao-trabalhadores-g1 (list 0)
  set lista-acc-educacao-trabalhadores-g3 (list 0)
  ask trabalhadores with [classe = 1] [ask patch-here [set lista-acc-educacao-trabalhadores-g1 lput [acc-escolas-prt-60minutos] of self lista-acc-educacao-trabalhadores-g1]]
  ask trabalhadores with [classe = 3] [ask patch-here [set lista-acc-educacao-trabalhadores-g3 lput [acc-escolas-prt-60minutos] of self lista-acc-educacao-trabalhadores-g3]]

  set lista-acc-saude-trabalhadores-g1 (list 0)
  set lista-acc-saude-trabalhadores-g3 (list 0)
  ask trabalhadores with [classe = 1] [ask patch-here [set lista-acc-saude-trabalhadores-g1 lput [acc-saude-prt-60minutos] of self lista-acc-saude-trabalhadores-g1]]
  ask trabalhadores with [classe = 3] [ask patch-here [set lista-acc-saude-trabalhadores-g3 lput [acc-saude-prt-60minutos] of self lista-acc-saude-trabalhadores-g3]]


  calc-mean-utility
  calc-mean-utility-comercios-outros
  calc-mean-utility-kibs-fires
  calc-mean-utility-educacoes
  calc-mean-utility-atacados
  calc-mean-utility-industrias
  setup-segregacao
  compute-lorenz-and-gini
  update-view

end

;==============================================================
; GO
;==============================================================

;; run the simulation
to go
  ask trabalhadores [
    set utility calc-utility classe patch-here p modo
    if satisfaction self = false and random-float 1 < dissatisfied-proportion ;; check if the agent is satisfied
    [
      ;; choose a random cell to relocate
      let candidate get-candidate classe
      if (calc-utility classe candidate p modo) > utility ;; test if the candidate place will offer higher utility than the current one
      [
        if relocate self candidate [
          set move-state "moved"
        ]
      ]
    ]
  ]

  ask atacados [
    let utilidade-agente utility
    if satisfaction-atacados self = false and random-float 1 < dissatisfied-proportion-comercios ;; check if the agent is satisfacted
    [
      let candidate get-candidate-workplace
      let valor calc-utility-atacados candidate
      if valor > utilidade-agente ;; test if the candidate place will offer higher utility than the current one
      [
        if relocate-comercio self candidate [
          set move-state "moved"
        ]
      ]
    ]
  ]

  ask educacoes [
    let utilidade-agente utility
    if satisfaction-educacoes self = false and random-float 1 < dissatisfied-proportion-comercios ;; check if the agent is satisfacted
    [
      let candidate get-candidate-workplace
      let valor calc-utility-educacoes candidate
      if valor > utilidade-agente ;; test if the candidate place will offer higher utility than the current one
      [
        if relocate-comercio self candidate [
          set move-state "moved"
        ]
      ]
    ]
  ]

  ask industrias [
    let utilidade-agente utility
    if satisfaction-industrias self = false and random-float 1 < dissatisfied-proportion-industrias ;; check if the agent is satisfacted
    [
      let candidate get-candidate-workplace
      let valor calc-utility-industrias candidate
      if valor > utilidade-agente ;; test if the candidate place will offer higher utility than the current one
      [
        if relocate-industria self candidate [
          set move-state "moved"
        ]
      ]
    ]
  ]

  ask kibs-fires [
    let utilidade-agente utility
    if satisfaction-kibs-fires self = false and random-float 1 < dissatisfied-proportion-comercios ;; check if the agent is satisfacted
    [
      let candidate get-candidate-workplace
      let valor calc-utility-kibs-fires candidate
      if valor > utilidade-agente ;; test if the candidate place will offer higher utility than the current one
      [
        if relocate-comercio self candidate [
          set move-state "moved"
        ]
      ]
    ]
  ]

  ask comercios-outros [
    let utilidade-agente utility
    if satisfaction-comercios-outros self = false and random-float 1 < dissatisfied-proportion-comercios ;; check if the agent is satisfacted
    [
      let candidate get-candidate-workplace
      let valor calc-utility-comercios-outros candidate
      if valor > utilidade-agente ;; test if the candidate place will offer higher utility than the current one
      [
        if relocate-comercio self candidate [
          set move-state "moved"
        ]
      ]
    ]
  ]

  calc-statistics
  setup-acc-agentes

  tick

end

;============================================================
;============================================================

to setup-acc
  ;;; calcula acessibilidade cumulativa a educacao em 60 minutos por transporte publico e privado
if cenario-transporte = "Linha-16-construida" [
    set matrix-tt-put-60minutos csv:from-file "matriz_OD_PuT_07AM_60minutos_novas_estacoes.csv"
    foreach matrix-tt-put-60minutos [ x ->
      set roww x
      set patch-referencia item 0 roww
      let total-educacao 0
      let total-lazer 0
      let total-ubs-postos 0
      let total-hospitais 0
      foreach roww [ y -> ask patches with [grid-code = y] [set total-educacao total-educacao + [num-educacao] of self set total-lazer total-lazer + [num-lazer] of self set total-ubs-postos total-ubs-postos + [num-ubs-postos] of self set total-hospitais total-hospitais + [num-hospitais] of self]]
      ask patches with [grid-code = patch-referencia] [set acc-escolas-put-60minutos total-educacao set acc-lazer-put-60minutos total-lazer set acc-saude-put-60minutos total-ubs-postos + (peso-hospital * total-hospitais)]]

    file-open "distancias_finais_variaveis.csv"
    while [not file-at-end?][
      let row csv:from-row file-read-line
      let orig-code item 0 row
      ask patches with [grid-code = orig-code][set distancia-centro-rede item 1 row set distancia-ensino-superior-rede item 2 row set distancia-hospital-rede item 3 row set distancia-parque-rede item 4 row set distancia-acesso-rodovia-rede item 5 row set distancia-acesso-arterial-rede item 6 row set distancia-est-trem-rede item 7 row set distancia-est-metro-rede item 9 row]
    ]
    file-close

    file-open "celulas_influencia_600m_linha_16_violeta.csv"
    while [not file-at-end?][
      let row csv:from-row file-read-line
      let orig-code item 0 row
      ask patches with [grid-code = orig-code][
        set acrescimo-habitacoes round (num-houses-per-cell * (13.304 + (-0.002 * [distancia-acesso-rodovia-rede] of self) + (-0.008 * [distancia-hospital-rede] of self) + (0.001 * [distancia-centro-rede] of self) + (-0.004 * [distancia-parque-rede] of self) + (0.005 * [distancia-acesso-arterial-rede] of self) + (0.003 * [distancia-ensino-superior-rede] of self) + (2.632 * 16)) / 100 )
        set acrescimo-empregos round (num-workplaces-total * (-9.253 + (0.002 * [distancia-acesso-rodovia-rede] of self) + (0.005 * [distancia-hospital-rede] of self) + (-0.001 * [distancia-centro-rede] of self) + (0 * [distancia-parque-rede] of self) + (-0.012 * [distancia-acesso-arterial-rede] of self) + (0.006 * [distancia-ensino-superior-rede] of self) + (1.897 * 16)) / 100)
        set num-houses-per-cell num-houses-per-cell + acrescimo-habitacoes
        set num-workplaces-total num-workplaces-total + acrescimo-empregos
        set num-workplaces-total-folga round (num-workplaces-total + (num-workplaces-total * 0.05))
      ]
    ]
    file-close

  ]

  if cenario-transporte = "Atual" [
  set matrix-tt-put-60minutos csv:from-file "matriz_OD_PuT_07AM_60minutos.csv"
  foreach matrix-tt-put-60minutos [ x ->
    set roww x
    set patch-referencia item 0 roww
    let total-educacao 0
    let total-lazer 0
    let total-ubs-postos 0
    let total-hospitais 0
    foreach roww [ y -> ask patches with [grid-code = y] [set total-educacao total-educacao + [num-educacao] of self set total-lazer total-lazer + [num-lazer] of self set total-ubs-postos total-ubs-postos + [num-ubs-postos] of self set total-hospitais total-hospitais + [num-hospitais] of self]]
      ask patches with [grid-code = patch-referencia] [set acc-escolas-put-60minutos total-educacao set acc-lazer-put-60minutos total-lazer set acc-saude-put-60minutos total-ubs-postos + (peso-hospital * total-hospitais)]]

    file-open "distancias_finais_variaveis.csv"
    while [not file-at-end?][
     let row csv:from-row file-read-line
     let orig-code item 0 row
      ask patches with [grid-code = orig-code][set distancia-centro-rede item 1 row set distancia-ensino-superior-rede item 2 row set distancia-hospital-rede item 3 row set distancia-parque-rede item 4 row set distancia-acesso-rodovia-rede item 5 row set distancia-acesso-arterial-rede item 6 row set distancia-est-trem-rede item 7 row set distancia-est-metro-rede item 8 row]
    ]
    file-close
  ]

  set matrix-tt-prt-60minutos csv:from-file "matriz_OD_PrT_07AM_60minutos.csv"
  foreach matrix-tt-prt-60minutos [ x ->
    set roww x
    set patch-referencia item 0 roww
    let total-educacao 0
    let total-lazer 0
    let total-ubs-postos 0
    let total-hospitais 0
    foreach roww [ y -> ask patches with [grid-code = y] [set total-educacao total-educacao + [num-educacao] of self set total-lazer total-lazer + [num-lazer] of self set total-ubs-postos total-ubs-postos + [num-ubs-postos] of self set total-hospitais total-hospitais + [num-hospitais] of self]]
    ask patches with [grid-code = patch-referencia] [set acc-escolas-prt-60minutos total-educacao set acc-lazer-prt-60minutos total-lazer set acc-saude-prt-60minutos total-ubs-postos + (peso-hospital * total-hospitais)]]

  let max-dist-educacao max [acc-escolas-prt-60minutos] of patches with [cell-type = 1] ;; find max dist-to-educacao
  let min-dist-educacao min [acc-escolas-put-60minutos] of patches with [cell-type = 1] ;; find mix dist-to-educacao
  let max-dist-lazer max [acc-lazer-prt-60minutos] of patches with [cell-type = 1] ;; find max dist-to-lazer
  let min-dist-lazer min [acc-lazer-put-60minutos] of patches with [cell-type = 1] ;; find mix dist-to-lazer
  let max-dist-saude max [acc-saude-prt-60minutos] of patches with [cell-type = 1] ;; find max dist-to-saude
  let min-dist-saude min [acc-saude-put-60minutos] of patches with [cell-type = 1] ;; find mix dist-to-saude
  ask patches with [cell-type = 1]
    [
      let dist_PuT_escolas acc-escolas-put-60minutos ;; get the dist-to-education to be normalized
      set dist-to-education-PuT-norm ((dist_PuT_escolas - min-dist-educacao) / (max-dist-educacao - min-dist-educacao)) ;; normalization
      let dist_PrT_escolas acc-escolas-prt-60minutos ;; get the dist-to-workplace to be normalized
      set dist-to-education-PrT-norm ((dist_PrT_escolas - min-dist-educacao) / (max-dist-educacao - min-dist-educacao)) ;; normalization

      let dist_PuT_lazer acc-lazer-put-60minutos ;; get the dist-to-education to be normalized
      set dist-to-lazer-PuT-norm ((dist_PuT_lazer - min-dist-lazer) / (max-dist-lazer - min-dist-lazer)) ;; normalization
      let dist_PrT_lazer acc-lazer-prt-60minutos ;; get the dist-to-workplace to be normalized
      set dist-to-lazer-PrT-norm ((dist_PrT_lazer - min-dist-lazer) / (max-dist-lazer - min-dist-lazer)) ;; normalization

      let dist_PuT_saude acc-saude-put-60minutos ;; get the dist-to-saude to be normalized
      set dist-to-saude-PuT-norm ((dist_PuT_saude - min-dist-saude) / (max-dist-saude - min-dist-saude)) ;; normalization
      let dist_PrT_saude acc-saude-prt-60minutos ;; get the dist-to-saude to be normalized
      set dist-to-saude-PrT-norm ((dist_PrT_saude - min-dist-saude) / (max-dist-saude - min-dist-saude)) ;; normalization
  ]

  set matrix-tt-walk-bicycle-put-10minutos csv:from-file "matriz_OD_walk_bicycle_PuT_07AM_10minutos.csv"
  foreach matrix-tt-walk-bicycle-put-10minutos [ x ->
    set roww x
    set patch-referencia item 0 roww
    let total-educacao 0
    let total-lazer 0
    let total-ubs-postos 0
    let total-hospitais 0
    let empregos 0
    foreach roww [ y -> ask patches with [grid-code = y] [set total-educacao total-educacao + [num-educacao] of self set total-lazer total-lazer + [num-lazer] of self set empregos count comercios-outros-here + count industrias-here + count atacados-here + count kibs-fires-here + count educacoes-here set total-ubs-postos total-ubs-postos + [num-ubs-postos] of self set total-hospitais total-hospitais + [num-hospitais] of self]]
    ask patches with [grid-code = patch-referencia] [set cidade-20-minutos-educacao total-educacao set cidade-20-minutos-lazer total-lazer set cidade-20-minutos-saude total-ubs-postos + (peso-hospital * total-hospitais) set cidade-20-minutos-empregos empregos set cidade-20-minutos-total cidade-20-minutos-educacao + cidade-20-minutos-lazer + cidade-20-minutos-saude + cidade-20-minutos-empregos]]

  let max-cidade-20minutos-educacao max [cidade-20-minutos-educacao] of patches with [cell-type = 1] ;; find max educacao
  let min-cidade-20minutos-educacao min [cidade-20-minutos-educacao] of patches with [cell-type = 1] ;; find mix educacao

  let max-cidade-20minutos-lazer max [cidade-20-minutos-lazer] of patches with [cell-type = 1] ;; find max lazer
  let min-cidade-20minutos-lazer min [cidade-20-minutos-lazer] of patches with [cell-type = 1] ;; find mix lazer

  let max-cidade-20minutos-saude max [cidade-20-minutos-saude] of patches with [cell-type = 1] ;; find max saude
  let min-cidade-20minutos-saude min [cidade-20-minutos-saude] of patches with [cell-type = 1] ;; find mix saude

  let max-cidade-20minutos-empregos max [cidade-20-minutos-empregos] of patches with [cell-type = 1] ;; find max emprego
  let min-cidade-20minutos-empregos min [cidade-20-minutos-empregos] of patches with [cell-type = 1] ;; find mix emprego

  ask patches with [cell-type = 1]
    [
      let cid-20-minutos-educacao cidade-20-minutos-educacao ;; get the dist-to-education to be normalized
      set cid-20-minutos-educacao-norm ((cid-20-minutos-educacao - min-cidade-20minutos-educacao) / (max-cidade-20minutos-educacao - min-cidade-20minutos-educacao)) ;; normalization

      let cid-20-minutos-lazer cidade-20-minutos-lazer ;; get the dist-to-workplace to be normalized
      set cid-20-minutos-lazer-norm ((cid-20-minutos-lazer - min-cidade-20minutos-lazer) / (max-cidade-20minutos-lazer - min-cidade-20minutos-lazer)) ;; normalization

      let cid-20-minutos-saude cidade-20-minutos-saude ;; get the dist-to-education to be normalized
      set cid-20-minutos-saude-norm ((cid-20-minutos-saude - min-cidade-20minutos-saude) / (max-cidade-20minutos-saude - min-cidade-20minutos-saude)) ;; normalization

      let cid-20-minutos-empregos cidade-20-minutos-empregos ;; get the dist-to-education to be normalized
      set cid-20-minutos-empregos-norm ((cid-20-minutos-empregos - min-cidade-20minutos-empregos) / (max-cidade-20minutos-empregos - min-cidade-20minutos-empregos)) ;; normalization

      set cid-20-minutos-total-norm cid-20-minutos-educacao-norm + cid-20-minutos-lazer-norm + cid-20-minutos-saude-norm + cid-20-minutos-empregos-norm
  ]
end

to setup-acc-agentes
  foreach matrix-tt-put-60minutos [ x ->
    set roww x
    set patch-referencia item 0 roww
    let total-agentes 0
    foreach roww [ y -> ask patches with [grid-code = y] [set total-agentes total-agentes + count comercios-outros-here + count industrias-here + count atacados-here + count kibs-fires-here + count educacoes-here]]
    ask patches with [grid-code = patch-referencia] [set total-agentes-emprego-acc-put-60minutos total-agentes]]

  foreach matrix-tt-prt-60minutos [ x ->
    set roww x
    set patch-referencia item 0 roww
    let total-agentes 0
    foreach roww [ y -> ask patches with [grid-code = y] [set total-agentes total-agentes + count comercios-outros-here + count industrias-here + count atacados-here + count kibs-fires-here + count educacoes-here]]
    ask patches with [grid-code = patch-referencia] [set total-agentes-emprego-acc-prt-60minutos total-agentes]]


  let max-dist max [total-agentes-emprego-acc-prt-60minutos] of patches with [cell-type = 1] ;; find max dist-to-workplace
  let min-dist min [total-agentes-emprego-acc-put-60minutos] of patches with [cell-type = 1] ;; find min dist-to-workplace
  ask patches with [cell-type = 1]
    [
      let dist_PuT total-agentes-emprego-acc-put-60minutos ;; get the dist-to-workplace to be normalized
      set dist-to-workplace_PuT ((dist_PuT - min-dist) / (max-dist - min-dist)) ;; normalization
      let dist_PrT total-agentes-emprego-acc-prt-60minutos ;; get the dist-to-workplace to be normalized
      set dist-to-workplace_PrT ((dist_PrT - min-dist) / (max-dist - min-dist)) ;; normalization
  ]

end


to setup-segregacao
  let c1-list trabalhadores with [classe = 1]
  let c2-list trabalhadores with [classe = 2]
  let c3-list trabalhadores with [classe = 3]
  let Nm-c1 count c1-list
  let Nm-c2 count c2-list
  let Nm-c3 count c3-list
  let population count trabalhadores
  ask patches[
    let pop-c1-cell count trabalhadores-here with [classe = 1]
    let pop-c2-cell count trabalhadores-here with [classe = 2]
    let pop-c3-cell count trabalhadores-here with [classe = 3]

    let pop-c1 count c1-list in-radius segregation-neighborhood
    let pop-c2 count c2-list in-radius segregation-neighborhood
    let pop-c3 count c3-list in-radius segregation-neighborhood

    let pop-neigh count trabalhadores in-radius segregation-neighborhood

    set iso-c1 compute-iso pop-c1-cell pop-c1 pop-neigh Nm-c1
    set iso-c2 compute-iso pop-c2-cell pop-c2 pop-neigh Nm-c2
    set iso-c3 compute-iso pop-c3-cell pop-c3 pop-neigh Nm-c3
  ]

  set sum-iso-c1 sum [iso-c1] of patches
  set sum-iso-c2 sum [iso-c2] of patches
  set sum-iso-c3 sum [iso-c3] of patches

  set sum-relative-iso-c1 sum [iso-c1] of patches - 0.1
  set sum-relative-iso-c2 sum [iso-c2] of patches - 0.3
  set sum-relative-iso-c3 sum [iso-c3] of patches - 0.6
end


to setup-public-housing
  if habitacao-social = "MCMV_Original" [
    file-open "Social_housing_MCMV_actual.csv"
    while [not file-at-end?] [
      let row csv:from-row file-read-line
      let orig-code item 0 row
      ask patches with [grid-code = orig-code] [set public-housing true set num-habitacoes-sociais item 1 row]
    ]
    file-close
  ]
  if habitacao-social = "ZEIS" [
    file-open "Social_housing_ZEIS.csv"
    while [not file-at-end?] [
      let row csv:from-row file-read-line
      let orig-code item 0 row
      ask patches with [grid-code = orig-code] [set public-housing true set num-habitacoes-sociais item 1 row]
    ]
    file-close
  ]

  if habitacao-social = "nao" [
    ask patches [set public-housing false set num-habitacoes-sociais 0]
  ]
end

to-report compute-iso [pop-group-cell pop-group-neigh pop-neigh Nm]
  report ifelse-value (pop-neigh != 0) [(pop-group-cell / Nm) * (pop-group-neigh / pop-neigh)] [0]
end

to-report get-candidate-by-distribution [class-id]
  let found false
  let x 0
  let y 0
  while [not found]
  [
    let ret []
    set ret random-uniform
    set x item 0 ret
    set y item 1 ret
    ask patch x y [
      if class-id = 3 and count trabalhadores-here < num-houses-per-cell [set found true]
      if class-id != 3 and count trabalhadores-here < num-houses-per-cell - num-habitacoes-sociais [set found true]
    ]
  ]
  report patch x y
end

to-report get-candidate-by-distribution-kibs-fires
  let found false
  let x 0
  let y 0
  while [not found]
  [
    let ret []
    set ret random-uniform
    set x item 0 ret
    set y item 1 ret
    ask patch x y [
      if count atacados-here + count educacoes-here + count comercios-outros-here + count kibs-fires-here + count industrias-here < num-workplaces-total [set found true]
    ]
  ]
  report patch x y
end

to-report get-candidate-by-distribution-comercios
  let found false
  let x 0
  let y 0
  while [not found]
  [
    let ret []
    set ret random-uniform
    set x item 0 ret
    set y item 1 ret
    ask patch x y [
      if count atacados-here + count educacoes-here + count comercios-outros-here + count kibs-fires-here + count industrias-here < num-workplaces-total [set found true]
    ]
  ]
  report patch x y
end



to-report get-candidate-by-distribution-educacao
  let found false
  let x 0
  let y 0
  while [not found]
  [
    let ret []
    set ret random-uniform
    set x item 0 ret
    set y item 1 ret
    ask patch x y [
      if count atacados-here + count educacoes-here + count comercios-outros-here + count kibs-fires-here + count industrias-here < num-workplaces-total [set found true]
    ]
  ]
  report patch x y
end

to-report get-candidate-by-distribution-atacado
  let found false
  let x 0
  let y 0
  while [not found]
  [
    let ret []
    set ret random-uniform
    set x item 0 ret
    set y item 1 ret
    ask patch x y [
      if count atacados-here + count educacoes-here + count comercios-outros-here + count kibs-fires-here + count industrias-here < num-workplaces-total [set found true]
    ]
  ]
  report patch x y
end


to-report get-candidate-by-distribution-industrias
  let found false
  let x 0
  let y 0
  while [not found]
  [
    let ret []
    set ret random-uniform
    set x item 0 ret
    set y item 1 ret
    ask patch x y [
      ;if count industrias-here < num-workplaces-total [set found true]
      if count atacados-here + count educacoes-here + count comercios-outros-here + count kibs-fires-here + count industrias-here < num-workplaces-total [set found true]
      ]
    ]
  report patch x y
end


to-report priority-of[id]
  report 4 - id
end

to-report random-uniform
  let rx random 48
  let ry random 73
  report (list rx ry)
end


to calc-mean-utility
  set mean-utility replace-item 0 mean-utility mean [utility] of trabalhadores
  set mean-utility replace-item 1 mean-utility mean [utility] of trabalhadores with [classe = 1]
  set mean-utility replace-item 2 mean-utility mean [utility] of trabalhadores with [classe = 2]
  set mean-utility replace-item 3 mean-utility mean [utility] of trabalhadores with [classe = 3]

  set mean-utility-total lput item 0 mean-utility mean-utility-total
  set mean-utility-c1 lput item 1 mean-utility mean-utility-c1
  set mean-utility-c2 lput item 2 mean-utility mean-utility-c2
  set mean-utility-c3 lput item 3 mean-utility mean-utility-c3

end

to calc-mean-utility-comercios-outros
  set mean-utility-comercios-outros mean [utility] of comercios-outros
end

to calc-mean-utility-kibs-fires
  set mean-utility-kibs-fires mean [utility] of kibs-fires
end

to calc-mean-utility-educacoes
  set mean-utility-educacoes mean [utility] of educacoes
end

to calc-mean-utility-atacados
  set mean-utility-atacados mean [utility] of atacados
end

to calc-mean-utility-industrias
  set mean-utility-industrias mean [utility] of industrias
end


to-report calc-utility [class-id cell prob mode]
  let dist_PuT [dist-to-workplace_PuT] of cell
  let dist_PrT [dist-to-workplace_PrT] of cell
  let cell-status [status] of cell
  if cell-status > 0 and class-id = 1 and mode = 0 [report (dist_PuT ^ alpha_c1) * (cell-status ^ (1 - alpha_c1))]
  if cell-status > 0 and class-id = 2 and mode = 0 [report (dist_PuT ^ alpha_c2) * (cell-status ^ (1 - alpha_c2))]
  if cell-status > 0 and class-id = 3 and mode = 0 [report (dist_PuT ^ alpha_c3) * (cell-status ^ (1 - alpha_c3))]

  if cell-status > 0 and class-id = 1 and mode = 1 [report (dist_PrT ^ alpha_c1) * (cell-status ^ (1 - alpha_c1))]
  if cell-status > 0 and class-id = 2 and mode = 1 [report (dist_PrT ^ alpha_c2) * (cell-status ^ (1 - alpha_c2))]
  if cell-status > 0 and class-id = 3 and mode = 1 [report (dist_PrT ^ alpha_c3) * (cell-status ^ (1 - alpha_c3))]

  if cell-status < 0 and class-id = 1 and mode = 0 [report (dist_PuT ^ alpha_c1) * (0 ^ (1 - alpha_c1))]
  if cell-status < 0 and class-id = 2 and mode = 0 [report (dist_PuT ^ alpha_c2) * (0 ^ (1 - alpha_c2))]
  if cell-status < 0 and class-id = 3 and mode = 0 [report (dist_PuT ^ alpha_c3) * (0 ^ (1 - alpha_c3))]

  if cell-status < 0 and class-id = 1 and mode = 1 [report (dist_PrT ^ alpha_c1) * (0 ^ (1 - alpha_c1))]
  if cell-status < 0 and class-id = 2 and mode = 1 [report (dist_PrT ^ alpha_c2) * (0 ^ (1 - alpha_c2))]
  if cell-status < 0 and class-id = 3 and mode = 1 [report (dist_PrT ^ alpha_c3) * (0 ^ (1 - alpha_c3))]
  report 0

end


to-report calc-utility-comercios-outros [cell]
  let total-comercio-vizinhanca [total-comercio-outros-norm] of cell
  ;let dens-pop [total-trabalhadores-norm] of cell
  ;let dist-cbd [distancia-centro-rede] of cell
  ;if dist-cbd = 0 [set dist-cbd 0.5]

  ;let n-kibs-fire [total-kibs-fires] of cell
  ;let n-educacao [total-educacoes] of cell

  ;let dist-metro [distancia-est-metro-rede] of cell
  ;let n-atacado [total-atacados] of cell

  let n-g1 [total-g1] of cell
  let dist-cbd [distancia-centro-rede] of cell
  let ensino-sup [distancia-ensino-superior-rede] of cell
  let dist-rod [distancia-acesso-rodovia-rede] of cell

  ;set utility ((1 / dist-cbd) / 3) + dens-pop - (total-comercio-vizinhanca * 2)

  ;set utility (0.922 * n-kibs-fire) + (3.873 * n-educacao) + (-0.003 * dist-cbd) + (0.002 * dist-rod) + (0.002 * dist-metro) + (1.896 * n-atacado) - (total-comercio-vizinhanca * 6)
  ;set utility (-0.003 * dist-cbd) + (0.002 * dist-rod) + (0.002 * dist-metro) + (1.896 * n-atacado) - (total-comercio-vizinhanca * 6)
  set utility (2.034 * n-g1) + (77.13 * dist-cbd) + (-0.003058 * ensino-sup) + (0.002809 * dist-rod) - (total-comercio-vizinhanca * 6)

  report utility

end


to-report calc-utility-kibs-fires [cell]
  let dens-kibs-fires [total-kibs-fires-norm] of cell
  ;let total-comercio-outros-celula [total-comercio-outros-norm] of cell
  ;let dist-cbd [distancia-centro-rede] of cell
  ;if dist-cbd = 0 [set dist-cbd 0.5]
  ;let n-atacados [total-atacados] of cell
  let n-g1 [total-g1] of cell
  let dist-cbd [distancia-centro-rede] of cell
  let dist-rod [distancia-acesso-rodovia-rede] of cell
  let dist-trem [distancia-est-trem-rede] of cell

  ;set utility total-comercio-outros-celula + (1 / dist-cbd) - (dens-kibs-fires * 2.5)
  ;set utility (2.939 * n-atacados) + (1.655 * n-g1) + (0.001 * dist-cbd)
  set utility (1.645 * n-g1) + (0.000689 * dist-rod)+ (-0.000832 * dist-trem) + (-0.000351 * dist-cbd) - (dens-kibs-fires * 2.5)
  report utility

end

to-report calc-utility-atacados [cell]
  ;let agentes-kibs-fire-norm [total-kibs-fires-norm] of cell ;variavel significativa na regressão linear
  ;let dens-atacados [total-atacados-norm] of cell
  ;let dist-trunks 0
  ;if [distancia-acesso-arterial-rede] of cell <= 5 [set dist-trunks 1]
  ;let dist-roads 0
  ;if [distancia-acesso-rodovia-rede] of cell <= 1 [set dist-roads 1]
  ;let dist-cbd 0
  ;if [distancia-centro-rede] of cell >= 5 and [distancia-centro-rede] of cell <= 10 [set dist-cbd 1]

  let n-kibs-fire [total-kibs-fires] of cell
  let n-armaz-ind [total-industrias] of cell
  let dist-cbd [distancia-centro-rede] of cell
  let dist-rod [distancia-acesso-rodovia-rede] of cell
  let dist-trem [distancia-est-trem-rede] of cell

  ;set utility  (2 * dist-trunks) + (dist-roads) + (dist-cbd) - (dens-atacados)
  ;set utility (0.088 * n-kibs-fire) + (0.281 * n-armaz-ind) + (-0.00015 * dist-cbd) ; verificar a variavel de dist-cbd no R
  set utility (-0.000106 * dist-cbd) + (0.000177 * dist-rod) + (-0.000329 * dist-trem)  ; verificar a variavel de dist-cbd no R
  report utility

end

to-report calc-utility-educacoes [cell]
  ;let pop_tot [total-trabalhadores-norm] of cell
  let educ_tot [total-educacoes-norm] of cell

  let n-g2 [total-g2] of cell
  let n-g1 [total-g1] of cell
  let ensino-sup [distancia-ensino-superior-rede] of cell
  let dist-rod [distancia-acesso-rodovia-rede] of cell
  ;let n-kibs-fire [total-kibs-fires] of cell

  ;set utility (pop_tot * 1.5) - (educ_tot / 1.5);]
  ;set utility (0.163 * n-g2) + (0.290 * n-g1) + (0.019 * n-kibs-fire) - (educ_tot / 1.5)
  set utility (0.163 * n-g2) + (0.290 * n-g1) + (-0.000216 * ensino-sup) + (0.0001133 * dist-rod) - (educ_tot / 1.5)

  report utility

end


to-report calc-utility-industrias [cell]
  let dens-ind [total-industrias-norm] of cell
  ;let dist-trunks 0
  ;if [distancia-acesso-arterial-rede] of cell <= 5 [set dist-trunks 1]
  ;let dist-roads 0
  ;if [distancia-acesso-rodovia-rede] of cell <= 1 [set dist-roads 1]
  ;let dist-cbd 0
  ;if [distancia-centro-rede] of cell <= 5 [set dist-cbd 1]

  ;let n-atacado [total-atacados] of cell
  let dist-cbd [distancia-centro-rede] of cell
  let dist-trem [distancia-est-trem-rede] of cell

  ;let n-g2 [total-g2] of cell
  let n-g1 [total-g1] of cell

  ;set utility dist-trunks + dist-roads + dist-cbd - (3 * dens-ind)
  ;set utility (0.613 * n-atacado) + (-0.00013 * dist-cbd) + (-0.29 * n-g1) + (-0.00016 * dist-trem)

  set utility (-0.000115 * dist-cbd) + (-0.2287 * n-g1) + (-0.0004022 * dist-trem) - (2 * dens-ind)

  report utility

end


to compute-lorenz-and-gini
  let l []
  ask trabalhadores [set l lput [count trabalhadores-here with [classe = 1] / count trabalhadores-here] of patch-here l]
  let ret calc-lorenz-and-gini l
  set segregation-lorenz-points-c1 item 0 ret
  set segregation-gini-index-reserve-c1 item 1 ret

  set l []
  ask trabalhadores [set l lput [count trabalhadores-here with [classe = 2] / count trabalhadores-here] of patch-here l]
  set ret calc-lorenz-and-gini l
  set segregation-lorenz-points-c2 item 0 ret
  set segregation-gini-index-reserve-c2 item 1 ret

  set l []
  ask trabalhadores [set l lput [count trabalhadores-here with [classe = 3] / count trabalhadores-here] of patch-here l]
  set ret calc-lorenz-and-gini l
  set segregation-lorenz-points-c3 item 0 ret
  set segregation-gini-index-reserve-c3 item 1 ret

  set l []
  ask trabalhadores [set l lput ([dist-to-workplace_PuT] of patch-here) l]
  set ret calc-lorenz-and-gini l
  set accessibility-lorenz-points-total item 0 ret
  set accessibility-gini-index-reserve-total item 1 ret

  set l []
  ask trabalhadores with [classe = 1] [set l lput ([dist-to-workplace_PuT] of patch-here) l]
  set ret calc-lorenz-and-gini l
  set accessibility-lorenz-points-c1 item 0 ret
  set accessibility-gini-index-reserve-c1 item 1 ret

  set l []
  ask trabalhadores with [classe = 2] [set l lput ([dist-to-workplace_PuT] of patch-here) l]
  set ret calc-lorenz-and-gini l
  set accessibility-lorenz-points-c2 item 0 ret
  set accessibility-gini-index-reserve-c2 item 1 ret

  set l []
  ask trabalhadores with [classe = 3] [set l lput ([dist-to-workplace_PuT] of patch-here) l]
  set ret calc-lorenz-and-gini l
  set accessibility-lorenz-points-c3 item 0 ret
  set accessibility-gini-index-reserve-c3 item 1 ret

  set l[]
  ask trabalhadores [set l lput priority l]
  set ret calc-lorenz-and-gini l
  set status-lorenz-points item 0 ret
  set status-gini-index-reserve item 1 ret
end

to-report calc-lorenz-and-gini [values]
  let sorted-values sort values
  let total-values sum sorted-values
  let values-sum-so-far 0
  let index 0
  let gini-index-reserve 0
  let lorenz-points []

  ;; now actually plot the Lorenz curve -- along the way, we also
  ;; calculate the Gini index.
  ;; (see the Info tab for a description of the curve and measure)
  let count-trabalhadores length values
  repeat count-trabalhadores [
    set values-sum-so-far (values-sum-so-far + item index sorted-values)
    set lorenz-points lput (values-sum-so-far / total-values ) lorenz-points
    set index index + 1
    set gini-index-reserve gini-index-reserve + (index / count-trabalhadores) - (values-sum-so-far / total-values )
  ]
  report (list lorenz-points gini-index-reserve)
end

to-report calc-cell-status [cell]
  let quantity max (list sum [count trabalhadores-here] of ([neighbors] of cell) 1)
  let my-status 0
  ask [neighbors] of cell
  [
    set my-status my-status + sum [priority] of trabalhadores-here
    ;print my-status
  ]
  report ((my-status / quantity) - 1) / 2 ;; normalization
end

;to-report calc-distance-to-roads [cell]
 ; ask cell [
  ;  let closest-road min-one-of patches with [roads = 1][distance myself]
   ; set distance-to-roads distance closest-road
  ;]
  ;report distance-to-roads
;end

;to-report calc-distance-to-railways [cell]
 ; ask cell [
  ;  let closest-railway min-one-of patches with [railways = 1][distance myself]
   ; set distance-to-railways distance closest-railway
  ;]
  ;report distance-to-railways
;end


;to-report calc-distance-to-trunks [cell]
 ; ask cell [
  ;  let closest-trunk min-one-of patches with [trunks = 1][distance myself]
   ; set distance-to-trunks distance closest-trunk
  ;]
  ;report distance-to-trunks
;end

;to-report calc-distance-to-transit [cell]
 ; ask cell [
  ;  let closest-transit min-one-of patches with [transit = 1][distance myself]
   ; set distance-to-transit distance closest-transit
  ;]
  ;report distance-to-transit
;end


to-report satisfaction [agent]
  ifelse compare-utility-strategy = "global"
  [
    ;; test if his utility is lower than the utility of all agents
    report [utility] of agent >= item 0 mean-utility
  ]
  [
    ;; test if his utility is lower than the utility of all agents with his class
    report [utility] of agent >= item [classe] of agent mean-utility
  ]
end


to-report satisfaction-comercios-outros [agent]
  report [utility] of agent >= mean-utility-comercios-outros
end


to-report satisfaction-atacados [agent]
  report [utility] of agent >= mean-utility-atacados
end


to-report satisfaction-kibs-fires [agent]
  report [utility] of agent >= mean-utility-kibs-fires
end


to-report satisfaction-educacoes [agent]
  report [utility] of agent >= mean-utility-educacoes
end

to-report satisfaction-industrias [agent]
  report [utility] of agent >= mean-utility-industrias
end

to-report get-candidate [class-id]
  let candidate one-of patches with [cell-type = 1]
  report candidate
end

to-report get-candidate-workplace
  let candidate one-of patches with [cell-type = 1 and num-workplaces-total > 0]
  report candidate
end

;to-report get-candidate-industria
 ; let candidate one-of patches with [cell-type = 1 and num-workplaces-industrial > 0]
  ;report candidate
;end

to-report relocate [agent candidate]
  let found false
  ask agent
  [
    ifelse available-housing candidate classe > 0 ;; just move if there is available house
    [
      move-to candidate
      set found true
    ]
    [
      let my-priority priority
      let my-class classe
      let old-place patch-here
      let hab-soc ([num-habitacoes-sociais] of candidate)
      let lower-priorities (available-candidates candidate) with [my-priority > priority] ;; try found agents with priority lower than itself
      if any? lower-priorities with [classe = 3] and count lower-priorities with [classe = 3] > hab-soc [
        ask self [move-to candidate] expel one-of lower-priorities with [classe = 3] set found true
        ]
      if any? lower-priorities with [classe = 2] and count lower-priorities with [classe = 3] <= hab-soc [
        ask self [move-to candidate] expel one-of lower-priorities with [classe = 2] set found true
      ]
    ]
  ]
  report found
end


to-report relocate-comercio [agent candidate]
  let found false
  ask agent
  [
    ;ifelse available candidate > 0 ;; alterado em 24/08 para ifelse ao inves de if
    if available candidate > 0
    [
      move-to candidate
      set found true
    ]
    ;[; aqui entra no else
     ;let lower-priorities [industrias-here] of candidate
     ;if any? lower-priorities and random 1000 < 1 [
      ;if any? lower-priorities [
        ;ask self [move-to candidate] expel-industria one-of lower-priorities set found true
      ;]
    ;]
  ]
  report found
end


to-report relocate-industria [agent candidate]
  let found false
  ask agent
  [
    if available candidate > 0 ;; just move if there is available house
    [
      move-to candidate
      set found true
    ]
  ]
  report found
end


to-report available-housing [cell class-id]
  report ifelse-value (class-id = 3 and [public-housing] of cell) [[num-houses-per-cell] of cell - count [trabalhadores-here] of cell] [[num-houses-per-cell] of cell  - count [trabalhadores-here] of cell - [num-habitacoes-sociais] of cell]
end


to-report available [cell]
  report [num-workplaces-total-folga] of cell - count [comercios-outros-here] of cell - count [industrias-here] of cell - count [educacoes-here] of cell - count [kibs-fires-here] of cell - count [atacados-here] of cell
end


to-report available-candidates [cell]
  report ([trabalhadores-here] of cell) with [classe != 1]
end

to expel [homeless]
  ask homeless
  [
    set move-state "expelled"
    let found false
    let min-utility item classe mean-utility
    while [not found]
    [
      let candidate one-of patches with [cell-type = 1 and (calc-utility [classe] of myself self [p] of myself [modo] of myself) >= min-utility] ;; filter only desirable places
      set found candidate != nobody and relocate self candidate ;; recursive call to rellocate the homeless agent and possible expell another agent
      set min-utility min-utility - 0.1 ; reduce the minimum acceptable utility
    ]
  ]
end


;to expel-industria [homeless-industria]
 ; ask homeless-industria
  ;[
    ;print who
   ; let utility-expelled [utility] of self
    ;set move-state "expelled"
    ;let found false
    ;let min-utility mean-utility-industrias
    ;while [not found]
    ;[
     ; let candidate one-of patches with [cell-type = 1 and num-workplaces-total > 0] ;; filter only desirable places
      ;let utilidade-temporaria calc-utility-industrias candidate
      ;if utilidade-temporaria > utility-expelled [
        ;print "found"
       ; set found candidate != nobody and relocate-industria self candidate
        ;set utility-expelled utility-expelled - 0.1]
      ;print "not found"
      ;set utility-expelled utility-expelled - 0.1 ; reduce the minimum acceptable utility
    ;]
  ;]
;end

to-report count-trabalhadores-of [class-id]
  report item (class-id - 1) num-trabalhadores-by-class
end

;==================================================
; VISUALIZAÇÃO
;==================================================

to update-view
  if view-mode = "trabalhadores" [view-trabalhadores]
  if view-mode = "comercios" [view-comercios]
  if view-mode = "ensino" [view-ensino]
  if view-mode = "kibs-fire" [view-kibs-fire]
  if view-mode = "atacados" [view-atacados]
  if view-mode = "industrias" [view-industrias]
  if view-mode = "acc-put-agentes" [view-acc-put-agentes]
  if view-mode = "acc-prt-agentes" [view-acc-prt-agentes]

  if view-mode = "acc-put-educacao" [view-acc-put-educacao]
  if view-mode = "acc-prt-educacao" [view-acc-prt-educacao]
  if view-mode = "acc-put-lazer" [view-acc-put-lazer]
  if view-mode = "acc-prt-lazer" [view-acc-prt-lazer]
  if view-mode = "acc-put-saude" [view-acc-put-saude]
  if view-mode = "acc-prt-saude" [view-acc-prt-saude]

  if view-mode = "acc-cidade-20minutos" [view-acc-cidade-20minutos]
  if view-mode = "acrescimo-habitacoes" [view-acrescimo-habitacoes]
  if view-mode = "acrescimo-empregos" [view-acrescimo-empregos]

  if view-mode = "hide-trabalhadores" [hide-trabalhadores]
  if view-mode = "iso-c1" [view-iso-c1]
  if view-mode = "iso-c2" [view-iso-c2]
  if view-mode = "iso-c3" [view-iso-c3]

  if view-mode = "cell-status" [view-cell-status]
  if view-mode = "spatial-utility-c1" [view-spatial-utility 1]
  if view-mode = "spatial-utility-c2" [view-spatial-utility 2]
  if view-mode = "spatial-utility-c3" [view-spatial-utility 3]

  if view-mode = "spatial-dissatisfied-c1" [view-spatial-dissatisfied 1]
  if view-mode = "spatial-dissatisfied-c2" [view-spatial-dissatisfied 2]
  if view-mode = "spatial-dissatisfied-c3" [view-spatial-dissatisfied 3]

  if view-mode = "acc-put" [view-accessibility-put 1]
  if view-mode = "acc-prt" [view-accessibility-prt 2]

end

to view-transit
  ask patches with [transit > 0] [set pcolor black]
end

to view-roads
  ask patches with [roads > 0] [set pcolor black]
end

to view-railways
  ask patches with [railways > 0] [set pcolor black]
end

to view-trunks
  ask patches with [trunks > 0] [set pcolor black]
end

to view-grade
  gis:set-drawing-color red
  gis:draw grade 1
end

to view-zonas
  gis:set-drawing-color 2
  gis:draw area-estudo 1
end


to view-acc-cidade-20minutos
  ask patches [set pcolor ifelse-value ([cid-20-minutos-total-norm] of self > 0) [scale-color red (cid-20-minutos-total-norm) max ([cid-20-minutos-total-norm] of patches) 0][gray]]
end

to view-acrescimo-habitacoes
  ask patches [set pcolor ifelse-value ([acrescimo-habitacoes] of self > 0) [scale-color red (acrescimo-habitacoes) max ([acrescimo-habitacoes] of patches) 0][gray]]
end

to view-acrescimo-empregos
  ask patches [set pcolor ifelse-value ([acrescimo-empregos] of self > 0) [scale-color red (acrescimo-empregos) max ([acrescimo-empregos] of patches) 0][gray]]
end

to view-acc-put-agentes
  ask patches [set pcolor ifelse-value ([total-agentes-emprego-acc-put-60minutos] of self > 0) [scale-color red (total-agentes-emprego-acc-put-60minutos) max ([total-agentes-emprego-acc-put-60minutos] of patches) 0][gray]]
end

to view-acc-prt-agentes
  ask patches [set pcolor ifelse-value ([total-agentes-emprego-acc-prt-60minutos] of self > 0) [scale-color red (total-agentes-emprego-acc-prt-60minutos) max ([total-agentes-emprego-acc-prt-60minutos] of patches) 0][gray]]
end


to view-acc-put-educacao
  ask patches [set pcolor ifelse-value ([acc-escolas-put-60minutos] of self > 0) [scale-color red (acc-escolas-put-60minutos) max ([acc-escolas-put-60minutos] of patches) 0][gray]]
end

to view-acc-prt-educacao
  ask patches [set pcolor ifelse-value ([acc-escolas-prt-60minutos] of self > 0) [scale-color red (acc-escolas-prt-60minutos) max ([acc-escolas-prt-60minutos] of patches) 0][gray]]
end


to view-acc-put-lazer
  ask patches [set pcolor ifelse-value ([acc-lazer-put-60minutos] of self > 0) [scale-color red (acc-lazer-put-60minutos) max ([acc-lazer-put-60minutos] of patches) 0][gray]]
end

to view-acc-prt-lazer
  ask patches [set pcolor ifelse-value ([acc-lazer-prt-60minutos] of self > 0) [scale-color red (acc-lazer-prt-60minutos) max ([acc-lazer-prt-60minutos] of patches) 0][gray]]
end

to view-acc-put-saude
  ask patches [set pcolor ifelse-value ([acc-saude-put-60minutos] of self > 0) [scale-color red (acc-saude-put-60minutos) max ([acc-saude-put-60minutos] of patches) 0][gray]]
end

to view-acc-prt-saude
  ask patches [set pcolor ifelse-value ([acc-saude-prt-60minutos] of self > 0) [scale-color red (acc-saude-prt-60minutos) max ([acc-saude-prt-60minutos] of patches) 0][gray]]
end




to view-workplace-comercial-outros [id]
  ask patches [set pcolor ifelse-value ([num-outros-comercios] of self > 0) [scale-color color-of-patches id (num-outros-comercios) max ([num-outros-comercios] of patches) 0][gray]]
  ;ask patches [set pcolor ifelse-value ([num-outros-comercios] of self > 0) [scale-color color-of-patches id (num-outros-comercios) 0 max ([num-outros-comercios] of patches)][gray]]
end

to view-workplace-kibs-fire [id]
  ask patches [set pcolor ifelse-value ([num-kibs-fire] of self > 0) [scale-color color-of-patches id (num-kibs-fire) max ([num-kibs-fire] of patches) 0][gray]]
end

to view-workplace-educacao [id]
  ask patches [set pcolor ifelse-value ([num-educacao] of self > 0) [scale-color color-of-patches id (num-educacao) max ([num-educacao] of patches) 0][gray]]
end

to view-workplace-atacados [id]
  ask patches [set pcolor ifelse-value ([num-atacados] of self > 0) [scale-color color-of-patches id (num-atacados) max ([num-atacados] of patches) 0][gray]]
end

to view-workplace-industrial [id]
  ask patches [set pcolor ifelse-value ([num-workplaces-industrial] of self > 0) [scale-color color-of-patches id (num-workplaces-industrial) max ([num-workplaces-industrial] of patches) 0][gray]]
end

to view-trabalhadores
  ask patches [
    let trabalhadores-list trabalhadores-here;
    let l (list
      (count trabalhadores-list with [classe = 1] / count-trabalhadores-of 1)
      (count trabalhadores-list with [classe = 2] / count-trabalhadores-of 2)
      (count trabalhadores-list with [classe = 3] / count-trabalhadores-of 3)
    )
    ;; note that max-ocurrence is relative to quantity of agents in each class
    let max-occurrence (position max l l) + 1

    set pcolor ifelse-value (count trabalhadores-list > 0) [color-of max-occurrence][gray]
  ]
end

to view-comercios
  ask patches [
    set pcolor ifelse-value (count comercios-outros-here > 0) [scale-color blue (count comercios-outros-here) max([num-outros-comercios] of patches) 0][gray]
    ;set pcolor ifelse-value (count comercios-outros-here > 0) [scale-color blue total-comercio-outros 0 50][gray]
    ]
end

to view-ensino
  ask patches [
    set pcolor ifelse-value (count educacoes-here > 0) [scale-color violet (count educacoes-here) max([num-educacao] of patches) 0][gray]
  ]
end

to view-kibs-fire
  ask patches [
    set pcolor ifelse-value (count kibs-fires-here > 0) [scale-color magenta (count kibs-fires-here) max([num-kibs-fire] of patches) 0][gray]
  ]
end


to view-atacados
  ask patches [
    set pcolor ifelse-value (count atacados-here > 0) [scale-color green (count atacados-here) max([num-atacados] of patches) 0][gray]
  ]
end

to view-industrias
  ask patches [
    ;set pcolor ifelse-value (count industrias-here > 0) [orange - count industrias-here / 10][gray]
    set pcolor ifelse-value (count industrias-here > 0) [scale-color red (count industrias-here) max ([num-workplaces-industrial] of patches) 0][gray]
  ]
end


to hide-trabalhadores
  ask trabalhadores [hide-turtle]
end

to view-public-housing
  ask patches [set pcolor ifelse-value(public-housing)[black][white]]
end

to view-accessibility-put [id]
  ask patches [set pcolor scale-color color-of id dist-to-workplace_PuT 1 0]
end

to view-accessibility-prt [id]
  ask patches [set pcolor scale-color color-of id dist-to-workplace_PrT 1 0]
end

to view-cell-status
  ask patches [set pcolor scale-color white (status) 1 0]
end

to view-spatial-dissatisfied [class-id]
  ask patches with [cell-type = 1][set pcolor scale-color color-of class-id count trabalhadores-here with [classe = class-id and satisfaction self = false] 0 num-houses-per-cell]
end

to-report color-of [id]
  let colors [black blue yellow red]
  report item id colors
end


to-report color-of-patches [id]
  let colors [blue red violet magenta green]
  report item id colors
end

to view-iso-c1
  ask patches [
    let max-iso-c1 max [iso-c1] of patches
    set pcolor scale-color blue iso-c1 max-iso-c1 0]
end


to view-iso-c2
  ask patches [
    let max-iso-c2 max [iso-c2] of patches
    set pcolor scale-color yellow iso-c2 max-iso-c2 0]
end

to view-iso-c3
  ask patches [
    let max-iso-c3 max [iso-c3] of patches
    set pcolor scale-color red iso-c3 max-iso-c3 0]
end

to view-spatial-utility [class-id]
  ask patches [
    let cits-here trabalhadores-here with [classe = class-id]
    set pcolor scale-color color-of class-id (ifelse-value (count cits-here > 0) [mean [utility] of cits-here] [0]) 1 0
  ]
end


to export
  let rows []
  set rows lput (list "id" "cell-id" "coord-x" "coord-y" "group" "accessibility" "utility" "cell-status") rows
  ask trabalhadores with [modo = 0][
    ;let accessibility [item [classe] of myself dist-to-workplace_PuT] of patch-here
    let accessibility [dist-to-workplace_PuT] of patch-here
    let patch-id [grid-code] of patch-here
    let row (list who patch-id ([pxcor] of patch-here) ([pycor] of patch-here) classe accessibility utility ([status] of patch-here))
    set rows lput row rows
  ]
  ask trabalhadores with [modo = 1][
    ;let accessibility [item [classe] of myself dist-to-workplace_PrT] of patch-here
    let accessibility [dist-to-workplace_Prt] of patch-here
    let patch-id [grid-code] of patch-here
    let row (list who patch-id ([pxcor] of patch-here) ([pycor] of patch-here) classe accessibility utility ([status] of patch-here))
    set rows lput row rows
  ]
  csv:to-file ("Resultados/agents.csv") rows
end




to export2
  let rows []
  set rows lput (list "id" "dist_road" "dist_railway" "dist_cbd" "dist_trunk" "dist_transit" "total_empregos_industrias" "total_empregos_comercios_outros" "total_empregos_atacadista" "total_empregos_ensino" "total_empregos_kibs_fire" "total_trabalhadores" "sp" "densidade_empregos_industria" "densidade_empregos_comercio_outros" "densidade_empregos_atacadista" "densidade_empregos_ensino" "densidade_empregos_kibs_fire") rows
  ask patches [
    let patch-id [grid-code] of self
    let row (list patch-id ([distancia-acesso-rodovia-rede] of self) ([distancia-est-trem-rede] of self) ([distancia-centro-rede] of self) ([distancia-acesso-arterial-rede] of self) ([distancia-est-metro-rede] of self) ([num-workplaces-industrial] of self) ([num-outros-comercios] of self) ([num-atacados] of self) ([num-educacao] of self) ([num-kibs-fire] of self) ([total-trabalhadores] of self) ([cell-type] of self) (sum[num-workplaces-industrial] of neighbors) (sum[num-outros-comercios] of neighbors) (sum[num-atacados] of neighbors) (sum[num-educacao] of neighbors) (sum[num-kibs-fire] of neighbors))
    set rows lput row rows
  ]
  csv:to-file ("Resultados/analise_08_09_2024.csv") rows
end
@#$#@#$#@
GRAPHICS-WINDOW
256
21
696
687
-1
-1
9.0
1
10
1
1
1
0
1
1
1
0
47
0
72
0
0
1
ticks
30.0

BUTTON
21
22
84
55
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1679
273
1777
306
view-acc-put
set view-mode \"acc-put\"\nview-accessibility-put 1
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1679
329
1776
362
view-acc-prt
set view-mode \"acc-prt\"\nview-accessibility-prt 3
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
19
69
215
102
segregation-neighborhood
segregation-neighborhood
0
10
3.0
1
1
NIL
HORIZONTAL

SLIDER
1392
437
1564
470
alpha_c1
alpha_c1
0
1
0.6
0.05
1
NIL
HORIZONTAL

PLOT
722
47
922
197
lorenz-curve-c1
pessoas
proportion
0.0
1.0
0.0
1.0
false
false
"" ""
PENS
"Lorenz" 1.0 0 -13345367 true "" "plot-pen-reset\nset-plot-pen-interval 1 / (length segregation-lorenz-points-c1)\nplot 0\nforeach segregation-lorenz-points-c1 plot"
"equal" 1.0 0 -16777216 true "plot 0\nplot 1" ""

TEXTBOX
997
12
1147
37
Segregação
20
0.0
1

PLOT
945
47
1145
197
lorenz-curve-c2
NIL
NIL
0.0
1.0
0.0
1.0
false
false
"" ""
PENS
"Lorenz" 1.0 0 -1184463 true "" "plot-pen-reset\nset-plot-pen-interval 1 / (length segregation-lorenz-points-c2)\nplot 0\nforeach segregation-lorenz-points-c2 plot"
"equal" 1.0 0 -16777216 true "plot 0\nplot 1" ""

PLOT
1166
47
1366
197
lorenz-curve-c3
NIL
NIL
0.0
1.0
0.0
1.0
false
false
"" ""
PENS
"Lorenz" 1.0 0 -2674135 true "" "plot-pen-reset\nset-plot-pen-interval 1 / (length segregation-lorenz-points-c3)\nplot 0\nforeach segregation-lorenz-points-c3 plot"
"equal" 1.0 0 -16777216 true "plot 0\nplot 1" ""

PLOT
723
243
923
393
lorenz-curve-c1_acc
NIL
NIL
0.0
1.0
0.0
1.0
false
false
"" ""
PENS
"Lorenz" 1.0 0 -14070903 true "" "plot-pen-reset\nset-plot-pen-interval 1 / (length accessibility-lorenz-points-c1)\nplot 0\nforeach accessibility-lorenz-points-c1 plot"
"equal" 1.0 0 -16777216 true "plot 0\nplot 1" ""

PLOT
945
240
1145
390
lorenz-curve-c2_acc
NIL
NIL
0.0
1.0
0.0
1.0
false
false
"" ""
PENS
"Lorenz" 1.0 0 -1184463 true "" "plot-pen-reset\nset-plot-pen-interval 1 / (length accessibility-lorenz-points-c2)\nplot 0\nforeach accessibility-lorenz-points-c2 plot"
"equal" 1.0 0 -16777216 true "plot 0\nplot 1" ""

PLOT
1162
240
1362
390
lorenz-curve-c3_acc
NIL
NIL
0.0
1.0
0.0
1.0
false
false
"" ""
PENS
"Lorenz" 1.0 0 -2674135 true "" "plot-pen-reset\nset-plot-pen-interval 1 / (length accessibility-lorenz-points-c3)\nplot 0\nforeach accessibility-lorenz-points-c3 plot"
"equal" 1.0 0 -16777216 true "plot 0\nplot 1" ""

TEXTBOX
987
210
1137
235
Acessibilidade
20
0.0
1

MONITOR
1608
322
1665
367
gini-c2
(accessibility-gini-index-reserve-c2 / count trabalhadores with [classe = 2]) / 0.5
3
1
11

MONITOR
1607
267
1664
312
gini-c1
(accessibility-gini-index-reserve-c1 / count trabalhadores with [classe = 1]) / 0.5
3
1
11

MONITOR
1609
374
1666
419
gini-c3
(accessibility-gini-index-reserve-c3 / count trabalhadores with [classe = 3]) / 0.5
3
1
11

MONITOR
1392
97
1449
142
gini-c2
(segregation-gini-index-reserve-c2 / count trabalhadores) / 0.5
3
1
11

MONITOR
1393
45
1450
90
gini-c1
(segregation-gini-index-reserve-c1 / count trabalhadores) / 0.5
3
1
11

MONITOR
1392
149
1449
194
gini-c3
(segregation-gini-index-reserve-c3 / count trabalhadores) / 0.5
3
1
11

TEXTBOX
969
402
1142
452
Utilidade Pessoas
20
0.0
1

PLOT
719
432
919
582
utility-c1
NIL
NIL
0.0
1.0
0.0
1200.0
false
false
"set-plot-y-range 0 count trabalhadores" ""
PENS
"c1" 0.025 1 -13345367 true "" "let trabalhadores-list trabalhadores with [classe = 1]\nhistogram [utility] of trabalhadores-list\n"

PLOT
945
432
1145
582
utility-c2
NIL
NIL
0.0
1.0
0.0
5500.0
false
false
"set-plot-y-range 0 count trabalhadores" ""
PENS
"default" 0.025 1 -1184463 true "" "let trabalhadores-list trabalhadores with [classe = 2]\nhistogram [utility] of trabalhadores-list"

PLOT
1165
432
1365
582
utility-c3
NIL
NIL
0.0
1.0
0.0
10500.0
false
false
"set-plot-y-range 0 count trabalhadores" ""
PENS
"c3" 0.025 1 -5298144 true "" "let trabalhadores-list trabalhadores with [classe = 3]\nhistogram [utility] of trabalhadores-list"

BUTTON
1475
52
1569
85
NIL
view-iso-c1
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1475
105
1569
138
NIL
view-iso-c2
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1476
155
1570
188
NIL
view-iso-c3
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
20
108
193
141
dissatisfied-proportion
dissatisfied-proportion
0
1
0.8
0.1
1
NIL
HORIZONTAL

CHOOSER
19
220
177
265
compare-utility-strategy
compare-utility-strategy
"global" "class"
1

BUTTON
104
23
167
56
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
223
732
330
766
show-trabalhadores
set view-mode \"trabalhadores\"\nview-trabalhadores
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
19
620
189
653
show-workplace-comercial-outros
set view-mode \"workplace-c1\"\nview-workplace-comercial-outros 0
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
34
659
174
692
show-workplace-industrial
set view-mode \"workplace-c2\"\nview-workplace-industrial 1
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
772
597
884
630
show-utility-c1
set view-mode \"spatial-utility-c1\"\nview-spatial-utility 1
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
990
599
1102
632
show-utility-c2
set view-mode \"spatial-utility-c2\"\nview-spatial-utility 2
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1209
600
1321
633
show-utility-c3
set view-mode \"spatial-utility-c3\"\nview-spatial-utility 3
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
757
643
900
676
show-dissatisfied-c1
set view-mode \"spatial-dissatisfied-c1\"\nview-spatial-dissatisfied 1
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
980
643
1123
676
show-dissatisfied-c2
set view-mode \"spatial-dissatisfied-c2\"\nview-spatial-dissatisfied 2
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1199
642
1342
675
show-dissatisfied-c3
set view-mode \"spatial-dissatisfied-c3\"\nview-spatial-dissatisfied 3
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
213
772
336
806
hide-show-trabalhadores
ask trabalhadores [\nifelse hidden? [\nshow-turtle]\n[hide-turtle]]\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
19
468
92
502
NIL
view-transit
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
1379
242
1579
392
lorenz-curve-geral
NIL
NIL
0.0
1.0
0.0
1.0
false
false
"" ""
PENS
"Lorenz" 1.0 0 -7500403 true "" "plot-pen-reset\nset-plot-pen-interval 1 / (length accessibility-lorenz-points-total)\nplot 0\nforeach accessibility-lorenz-points-total plot"
"equal" 1.0 0 -16777216 true "plot 0\nplot 1" ""

MONITOR
1605
217
1667
262
gini-total
(accessibility-gini-index-reserve-total / count trabalhadores) / 0.5
3
1
11

BUTTON
19
429
93
463
NIL
view-zonas
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
20
270
158
315
Distrib-trab
Distrib-trab
"Real" "Aleatoria"
1

BUTTON
1033
728
1088
761
NIL
export
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
1393
484
1565
517
alpha_c2
alpha_c2
0
1
1.0
0.05
1
NIL
HORIZONTAL

SLIDER
1393
528
1565
561
alpha_c3
alpha_c3
0
1
0.2
0.05
1
NIL
HORIZONTAL

CHOOSER
20
320
128
365
habitacao-social
habitacao-social
"MCMV_Original" "ZEIS" "nao"
2

BUTTON
138
325
240
359
NIL
view-public-housing
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
112
429
178
463
NIL
view-grade
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
363
732
484
766
show-comercios-outros
set view-mode \"comercios\"\nview-comercios
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
509
732
638
766
show-industrias-armazens
set view-mode \"industrias\"\nview-industrias
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
353
772
493
806
hide-show-comercios-outros
ask comercios-outros [\nifelse hidden? [\nshow-turtle]\n[hide-turtle]]\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
503
770
657
804
hide-show-industrias-armazens
ask industrias [\nifelse hidden? [\nshow-turtle]\n[hide-turtle]]\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
114
468
178
502
NIL
view-roads
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
19
508
98
542
NIL
view-railways
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
20
145
210
178
dissatisfied-proportion-comercios
dissatisfied-proportion-comercios
0
1
0.8
0.1
1
NIL
HORIZONTAL

SLIDER
19
183
205
216
dissatisfied-proportion-industrias
dissatisfied-proportion-industrias
0
1
0.8
0.1
1
NIL
HORIZONTAL

BUTTON
1034
770
1089
803
NIL
export2
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
113
508
182
542
NIL
view-trunks
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
669
730
749
764
show-ensino
set view-mode \"ensino\"\nview-ensino
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
778
729
860
763
show-kibs-fire
set view-mode \"kibs-fire\"\nview-kibs-fire
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
897
730
982
764
show-atacados
set view-mode \"atacados\"\nview-atacados
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
668
770
758
804
hide-show-ensino
ask educacoes [\nifelse hidden? [\nshow-turtle]\n[hide-turtle]]\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
769
770
871
805
hide-show-kibs-fire
ask kibs-fires [\nifelse hidden? [\nshow-turtle]\n[hide-turtle]]\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
888
770
993
805
hide-show-atacados
ask atacados [\nifelse hidden? [\nshow-turtle]\n[hide-turtle]]\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
34
698
167
731
show-workplace-educacao
set view-mode \"workplace-c2\"\nview-workplace-educacao 2
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
38
738
169
771
show-workplace-kibs-fire
set view-mode \"workplace-c2\"\nview-workplace-kibs-fire 3
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
38
779
167
812
show-workplace-atacados
set view-mode \"workplace-c2\"\nview-workplace-atacados 4
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
44
590
194
610
Distribuição Real
16
0.0
1

TEXTBOX
505
700
719
722
Distribuição Simulada
16
0.0
1

BUTTON
49
548
154
583
NIL
clear-drawing
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1124
727
1279
762
show-acc-put-emprego
set view-mode \"acc-put-agentes\"\nview-acc-put-agentes
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1125
772
1278
806
show-acc-prt-emprego
set view-mode \"acc-prt-agentes\"\nview-acc-prt-agentes
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1289
727
1447
761
show-acc-put-educacao
set view-mode \"acc-put-educacao\"\nview-acc-put-educacao
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1292
770
1447
804
show-acc-prt-educacao
set view-mode \"acc-prt-educacao\"\nview-acc-prt-educacao
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1459
725
1593
759
show-acc-put-lazer
set view-mode \"acc-put-lazer\"\nview-acc-put-lazer
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1462
770
1594
804
show-acc-prt-lazer
set view-mode \"acc-prt-lazer\"\nview-acc-prt-lazer
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
1610
435
1745
480
Palma G1/G3 (Empregos)
median lista-acc-empregos-trabalhadores-g1 / median lista-acc-empregos-trabalhadores-g3
2
1
11

MONITOR
1608
490
1746
535
Palma G1/G3 (Educacao)
median lista-acc-educacao-trabalhadores-g1 / median lista-acc-educacao-trabalhadores-g3
2
1
11

MONITOR
1610
542
1745
587
Palma G1/G3 (Lazer)
median lista-acc-lazer-trabalhadores-g1 / median lista-acc-lazer-trabalhadores-g3
2
1
11

BUTTON
1605
727
1745
761
show-acc-put-saude
set view-mode \"acc-put-saude\"\nview-acc-put-saude
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1607
770
1744
804
show-acc-prt-saude
set view-mode \"acc-prt-saude\"\nview-acc-prt-saude
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
1610
600
1745
645
Palma G1/G3 (Saude)
median lista-acc-saude-trabalhadores-g1 / median lista-acc-saude-trabalhadores-g3
2
1
11

BUTTON
1418
643
1576
677
show-cidade-20minutos
set view-mode \"acc-cidade-20minutos\"\nview-acc-cidade-20minutos
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
1397
587
1570
620
peso-hospital
peso-hospital
1
10
5.0
1
1
NIL
HORIZONTAL

CHOOSER
21
370
173
415
cenario-transporte
cenario-transporte
"Atual" "Linha-16-construida"
1

BUTTON
1597
92
1776
126
show-acrescimo-habitacoes
set view-mode \"acrescimo-habitacoes\"\nview-acrescimo-habitacoes
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1600
138
1772
172
view-acrescimo-empregos
set view-mode \"acrescimo-empregos\"\nview-acrescimo-empregos
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
