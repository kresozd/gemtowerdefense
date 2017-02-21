var towers = {
  gem_Silver: {
    Type: "Advanced",
    Requirements: {
      1: "gem_d1",
      2: "gem_s1",
      3: "gem_t1",
    }
  },
  gem_Malachite: {
    Type: "Advanced",
    Requirements: {
      1: "gem_e1",
      2: "gem_o1",
      3: "gem_q1",
    }
  },
  gem_Flame_Ruby: {
    Type: "Advanced",
    Requirements: {
      1: "gem_a1",
      2: "gem_r1",
      3: "gem_r2",
    }
  },
  gem_Silver_Knight: {
    Type: "Advanced",
    Requirements: {
      1: "gem_Silver",
      2: "gem_q2",
      3: "gem_r3",
    }
  },
  gem_Huge_Malachite: {
    Type: "Advanced",
    Requirements: {
      1: "gem_Malachite",
      2: "gem_d2",
      3: "gem_t3",
    }
  },
  gem_Volcano: {
    Type: "Advanced",
    Requirements: {
      1: "gem_Flame_Ruby",
      2: "gem_r4",
      3: "gem_a3",
    }
  },
  gem_Quartz: {
    Type: "Advanced",
    Requirements: {
      1: "gem_e4",
      2: "gem_r3",
      3: "gem_a2",
    }
  },
  gem_Charming_Lazurite: {
    Type: "Advanced",
    Requirements: {
      1: "gem_Quartz",
      2: "gem_a4",
      3: "gem_t2",
    }
  },
  gem_Jade: {
    Type: "Advanced",
    Requirements: {
      1: "gem_e3",
      2: "gem_o3",
      3: "gem_s2",
    }
  },
  gem_Lucky_Chinese_Jade: {
    Type: "Advanced",
    Requirements: {
      1: "gem_Jade",
      2: "gem_Quartz",
      3: "gem_e3",
    }
  },
  gem_Grey_Jade: {
    Type: "Advanced",
    Requirements: {
      1: "gem_Jade",
      2: "gem_s4",
      3: "gem_s3",
    }
  },
  gem_Dark_Emerald: {
    Type: "Advanced",
    Requirements: {
      1: "gem_e5",
      2: "gem_s4",
      3: "gem_t2",
    }
  },
  gem_Emerald_Golem: {
    Type: "Advanced",
    Requirements: {
      1: "gem_Gold",
      2: "gem_Dark_Emerald",
      3: "gem_d3",
    }
  },
  gem_Yellow_Sapphire: {
    Type: "Advanced",
    Requirements: {
      1: "gem_s5",
      2: "gem_t4",
      3: "gem_r4",
    }
  },
  gem_Gold: {
    Type: "Advanced",
    Requirements: {
      1: "gem_a5",
      2: "gem_a4",
      3: "gem_d2",
    }
  },
  gem_Egypt_Gold: {
    Type: "Advanced",
    Requirements: {
      1: "gem_Gold",
      2: "gem_a5",
      3: "gem_q3",
    }
  },
  gem_Pink_Diamond: {
    Type: "Advanced",
    Requirements: {
      1: "gem_d5",
      2: "gem_d3",
      3: "gem_t3",
    }
  },
  gem_Huge_Pink_Diamond: {
    Type: "Advanced",
    Requirements: {
      1: "gem_Pink_Diamond",
      2: "gem_Silver_Knight",
      3: "gem_Silver",
    }
  },
  gem_Bloodstone: {
    Type: "Advanced",
    Requirements: {
      1: "gem_r5",
      2: "gem_q4",
      3: "gem_a3",
    }
  },
  gem_Antique_Bloodstone: {
    Type: "Advanced",
    Requirements: {
      1: "gem_Bloodstone",
      2: "gem_Volcano",
      3: "gem_r2",
    }
  },
  gem_Uranium_238: {
    Type: "Advanced",
    Requirements: {
      1: "gem_t5",
      2: "gem_s3",
      3: "gem_o2",
    }
  },
  gem_Uranium_235: {
    Type: "Advanced",
    Requirements: {
      1: "gem_Uranium_238",
      2: "gem_Huge_Malachite",
      3: "gem_Malachite",
    }
  },
  gem_Chrysoberyl_Cats_Eye: {
    Type: "Advanced",
    Requirements: {
      1: "gem_o5",
      2: "gem_d4",
      3: "gem_q3",
    }
  },
  gem_DeepSea_Pearl: {
    Type: "Advanced",
    Requirements: {
      1: "gem_q4",
      2: "gem_d4",
      3: "gem_o2",
    }
  },
  gem_Red_Coral: {
    Type: "Advanced",
    Requirements: {
      1: "gem_Chrysoberyl_Cats_Eye",
      2: "gem_DeepSea_Pearl",
      3: "gem_o4",
    }
  },
  gem_Paraiba_Tourmaline: {
    Type: "Advanced",
    Requirements: {
      1: "gem_q5",
      2: "gem_o4",
      3: "gem_e2",
    }
  },
  gem_Elaborately_Carved_Tourmaline: {
    Type: "Advanced",
    Requirements: {
      1: "gem_Paraiba_Tourmaline",
      2: "gem_Dark_Emerald",
      3: "gem_e2",
    }
  }
};


function initFormulaRows(data) {
  var towers = data || {};
  for (var tower in towers) {
    if (towers[tower].Requirements) {
      initComponents(towers[tower], tower)
    }
  }
}


function initComponents(tower, towerName) {
  var towerComponents = tower.Requirements || {};

  towerRow = $.CreatePanel('Panel', $.GetContextPanel(), towerName)
  towerRow.AddClass('formula-row');
  for (var component in towerComponents) {
    createTowerPanel(towerRow, towerComponents[component]);
    
    var formulaMark = $.CreatePanel('Label', towerRow, '');
    formulaMark.AddClass('formula-mark');

    formulaMark.text = Object.keys(towerComponents).length > component ? '+' : '=';
  }

  createTowerPanel(towerRow, towerName, true);
}


function createTowerPanel(container, tower, isFinal) {
  var towerPanel = $.CreatePanel('Panel', container, isFinal ? tower : '');

  towerPanel.BLoadLayoutSnippet('formula-item');
  towerPanel.AddClass(tower);

  var towerImg = tower.length > 6 ? tower : tower.slice(0, 5);
  var towerInner = towerPanel.FindChildTraverse('formula-tower-inner');
  towerInner.style.backgroundImage = "url(\"file://{resources}/images/custom_game/gems/" + towerImg + ".png\")";

  var towerLabel = towerPanel.FindChildTraverse('component-name');
  towerLabel.text = $.Localize('#' + tower);

  if (isFinal) {
    towerPanel.AddClass('formula-result');
    setUpTowerTooltip(towerPanel, tower);
  }
}


function setUpTowerTooltip(towerPanel, towerName) {
  
  var showTooltip = function() {

    // we need to apply tooltip target properly according to table state minimized/expanded
    var isMinimized = $.GetContextPanel().BHasClass('tab-formula-min');
    var towerInner = towerPanel.FindChildTraverse('formula-tower-inner');
    var target = isMinimized ? towerPanel : towerInner;

    $.DispatchEvent("UIShowCustomLayoutParametersTooltip", target, "formulaTooltip", "file://{resources}/layout/custom_game/tooltips/formula_tooltip.xml", "towerName=" + towerName + "&towerType=" + towers[towerName].Type);
  }

  towerPanel.SetPanelEvent("onmouseover", showTooltip)

  towerPanel.SetPanelEvent(
    "onmouseout",
    function() {
      $.DispatchEvent("UIHideCustomLayoutTooltip", "formulaTooltip");
    }
  );
}


(function() {
  initFormulaRows(towers);
})();