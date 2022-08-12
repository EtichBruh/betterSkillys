package kabam.rotmg.essences.view {
import com.company.assembleegameclient.ui.Scrollbar;

import flash.display.Graphics;

import flash.display.Shape;

import flash.display.Sprite;

import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;

import kabam.rotmg.PotionStorage.*;

import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.Player;
import com.gskinner.motion.GTween;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;

import io.decagames.rotmg.ui.buttons.SliceScalingButton;
import io.decagames.rotmg.ui.popups.header.PopupHeader;
import io.decagames.rotmg.ui.popups.modal.ModalPopup;
import io.decagames.rotmg.ui.texture.TextureParser;
import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.essences.view.components.EssenceGauge;
import kabam.rotmg.essences.view.components.TalismanSlot;
import kabam.rotmg.game.model.GameModel;
import kabam.rotmg.game.signals.AddTextLineSignal;

import org.osflash.signals.Signal;

public class EssenceView extends ModalPopup {

    public var gs_:GameSprite;
    public var gameObject:GameObject;
    public var essenceGague_:EssenceGauge;
    internal var quitButton:SliceScalingButton;
    internal var player:Player;
    internal var text_:String;

    internal var close:Signal = new Signal();

    public var sprite_:Sprite;
    public var slotsContainer_:Sprite;

    public var upgrade_:SliceScalingButton;

    private var slotsScrollBar_:Scrollbar;

    public var slots_:Vector.<TalismanSlot>;

    public function EssenceView(gs:GameSprite, go:GameObject) {
        this.gs_ = gs;
        this.gameObject = go;
        super(600, 425, "Talisman Essence");

        this.essenceGague_ = new EssenceGauge();
        this.essenceGague_.setCapacity(32000);
        this.essenceGague_.setMaxCapacity(32000);
        this.essenceGague_.x = 16;
        this.essenceGague_.y = 16;
        addChild(this.essenceGague_);

        this.sprite_ = new Sprite();
        this.slotsContainer_ = new Sprite();
        var shape:Shape = new Shape();
        var g:Graphics = shape.graphics;
        g.beginFill(0);
        g.drawRect(64, 16, 600, 425);
        g.endFill();
        this.sprite_.addChild(shape);
        this.sprite_.mask = shape;
        this.sprite_.addChild(this.slotsContainer_);
        addChild(this.sprite_);

        this.slots_ = new Vector.<TalismanSlot>();
        for(var i = 0; i < 32; i++)
        {
            var slot:TalismanSlot = new TalismanSlot(152, 96, i);
            slot.x = 96 + 72 + slot.w_ * int(i % 3) + 70 - slot.width;
            slot.y = 16 + slot.h_ * int(i / 3);
            this.slotsContainer_.addChild(slot);

            if(i % 2 == 0){
                slot.setTier(1);
            }
            slot.setLevel(i % 20);

            slot.setExp(Math.random() * 512);
            slot.setExpGoal(512);

            this.slots_.push(slot);
        }

        if (this.slotsContainer_.height > 400)
        {
            this.slotsScrollBar_ = new Scrollbar(16, 400);
            this.slotsScrollBar_.x = 578;
            this.slotsScrollBar_.y = 16;
            this.slotsScrollBar_.setIndicatorSize(400, this.slotsContainer_.height);
            this.slotsScrollBar_.addEventListener(Event.CHANGE, this.onResultScrollChanged);
            addChild(this.slotsScrollBar_);
        }

        this.quitButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "close_button"));
        this.header.addButton(this.quitButton, PopupHeader.RIGHT_BUTTON);
        this.quitButton.addEventListener(MouseEvent.CLICK, this.onClose);

        this.upgrade_ = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "generic_green_button"));
        this.upgrade_.width = 96;
        this.upgrade_.setLabel("Upgrade", DefaultLabelFormat.defaultModalTitle);
        this.upgrade_.x = 0;
        this.upgrade_.y = 425 - this.upgrade_.height - 4;
        addChild(this.upgrade_);

        this.x = this.width / 2 - 235;
        this.y = this.height / 2 - 230;

        this.draw();

        this.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    }


    private function onResultScrollChanged(event:Event) : void
    {
        this.slotsContainer_.y = -this.slotsScrollBar_.pos() * (this.slotsContainer_.height - 400);
    }

    public function onEnterFrame(_arg1:Event):void{
        this.essenceGague_.draw();
    }

    public function onClose(arg1:Event):void {
        this.quitButton.removeEventListener(MouseEvent.CLICK, this.onClose);
        this.close.dispatch();
    }

    public function draw():void {
        this.essenceGague_.draw();
        for (var i:int = 0; i < this.slots_.length; i++) {
            this.slots_[i].draw();
        }
    }
}
}
